import 'dart:convert';
import 'package:dilidili/model/read/opus.dart';
import 'package:html/parser.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/model/read/read.dart';

class ReadHttp {
  static Map<String, dynamic> _parseInitialState(String htmlContent) {
    const String marker = 'window.__INITIAL_STATE__=';
    final int markerIndex = htmlContent.indexOf(marker);
    if (markerIndex == -1) {
      throw const FormatException('未找到文章页面初始化数据');
    }

    final int startIndex =
        htmlContent.indexOf('{', markerIndex + marker.length);
    if (startIndex == -1) {
      throw const FormatException('文章页面初始化数据格式错误');
    }

    int depth = 0;
    bool inString = false;
    bool escaping = false;
    for (int i = startIndex; i < htmlContent.length; i++) {
      final String char = htmlContent[i];
      if (inString) {
        if (escaping) {
          escaping = false;
        } else if (char == '\\') {
          escaping = true;
        } else if (char == '"') {
          inString = false;
        }
        continue;
      }

      if (char == '"') {
        inString = true;
      } else if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;
        if (depth == 0) {
          final dynamic data =
              json.decode(htmlContent.substring(startIndex, i + 1));
          if (data is Map<String, dynamic>) {
            return data;
          }
          throw const FormatException('文章页面初始化数据不是对象');
        }
      }
    }

    throw const FormatException('文章页面初始化数据不完整');
  }

  static List<String> extractScriptContents(String htmlContent) {
    RegExp scriptRegExp = RegExp(r'<script>([\s\S]*?)<\/script>');
    Iterable<Match> matches = scriptRegExp.allMatches(htmlContent);
    List<String> scriptContents = [];
    for (Match match in matches) {
      String scriptContent = match.group(1)!;
      scriptContents.add(scriptContent);
    }
    return scriptContents;
  }

  static Future parseArticleOpus({required String id}) async {
    var res = await DioInstance.instance()
        .get(path: 'https://www.bilibili.com/opus/$id', extra: {'ua': 'pc'});
    String? headContent = parse(res.data).head?.outerHtml;
    var document = parse(headContent);
    var linkTags = document.getElementsByTagName('link');
    bool isCv = false;
    String cvId = '';
    for (var linkTag in linkTags) {
      var attributes = linkTag.attributes;
      if (attributes.containsKey('rel') && attributes['rel'] == 'canonical') {
        final String cvHref = linkTag.attributes['href']!;
        RegExp regex = RegExp(r'cv(\d+)');
        RegExpMatch? match = regex.firstMatch(cvHref);
        if (match != null) {
          cvId = match.group(1)!;
          isCv = true;
          break;
        }
      }
    }
    Map<String, dynamic> jsonData = _parseInitialState(res.data.toString());
    return {
      'status': true,
      'data': OpusDataModel.fromJson(jsonData),
      'isCv': isCv,
      'cvId': cvId,
    };
  }

  // 解析专栏 cv格式
  static Future parseArticleCv({required String id}) async {
    var res = await DioInstance.instance().get(
      path: 'https://www.bilibili.com/read/cv$id/?opus_fallback=1',
      extra: {'ua': 'pc'},
    );
    String scriptContent =
        extractScriptContents(parse(res.data).body!.outerHtml)[0];
    int startIndex = scriptContent.indexOf('{');
    int endIndex = scriptContent.lastIndexOf('};');
    String jsonContent = scriptContent.substring(startIndex, endIndex + 1);
    Map<String, dynamic> jsonData = json.decode(jsonContent);
    return {
      'status': true,
      'data': ReadDataModel.fromJson(jsonData),
    };
  }
}

import 'dart:convert';
import 'package:html/parser.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/model/read/read.dart';

class ReadHttp {
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

  // 解析专栏 cv格式
  static Future parseArticleCv({required String id}) async {
    var res = await DioInstance.instance().get(
      path: 'https://www.bilibili.com/read/cv${id}/?opus_fallback=1',
      extra: {'ua': 'pc'},
    );
    String scriptContent =
        extractScriptContents(parse(res.data).body!.outerHtml)[0];
    int startIndex = scriptContent.indexOf('{');
    int endIndex = scriptContent.lastIndexOf('};');
    String jsonContent = scriptContent.substring(startIndex, endIndex + 1);
    // 解析JSON字符串为Map
    Map<String, dynamic> jsonData = json.decode(jsonContent);
    return {
      'status': true,
      'data': ReadDataModel.fromJson(jsonData),
    };
  }
}

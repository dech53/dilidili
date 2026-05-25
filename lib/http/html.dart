import 'dart:convert';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class HtmlHttp {
  static Map<String, dynamic>? _parseInitialState(String html) {
    final Match? match = RegExp(
      r'window\.__INITIAL_STATE__=(\{.*?\});\(function',
      dotAll: true,
    ).firstMatch(html);
    if (match == null) {
      return null;
    }
    final dynamic data = jsonDecode(match.group(1)!);
    return data is Map<String, dynamic> ? data : null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String _normalImageUrl(String? src) {
    if (src == null || src.isEmpty) return '';
    final String url = src.split('@')[0];
    return url.startsWith('//') ? 'https:$url' : url;
  }

  // article
  static Future reqHtml(id, dynamicType) async {
    var response = await DioInstance.instance().get(
      path: "https://www.bilibili.com/opus/$id",
      extra: {'ua': 'pc'},
    );

    if (response.data.contains('Redirecting to')) {
      RegExp regex = RegExp(r'//([\w\.]+)/(\w+)/(\w+)');
      Match match = regex.firstMatch(response.data)!;
      String matchedString = match.group(0)!;
      response = await DioInstance.instance().get(
        path: 'https:$matchedString/',
        extra: {'ua': 'pc'},
      );
    }
    try {
      final Map<String, dynamic>? initialState =
          _parseInitialState(response.data);
      final Map? detail = initialState?['detail'];
      final Map? basic = detail?['basic'];
      final int? initialCommentId =
          _parseInt(basic?['comment_id_str'] ?? basic?['rid_str']);

      Document rootTree = parse(response.data);
      // log(response.data.body.toString());
      Element body = rootTree.body!;
      Element appDom = body.querySelector('#app')!;
      Element? authorHeader = appDom.querySelector('.fixed-author-header') ??
          appDom.querySelector('.opus-module-author');
      // 头像
      String avatar = _normalImageUrl(
        authorHeader?.querySelector('img')?.attributes['src'] ??
            detail?['modules']?[0]?['module_author']?['face'],
      );
      String uname = authorHeader
              ?.querySelector('.fixed-author-header__author__name')
              ?.text ??
          authorHeader?.querySelector('.opus-module-author__name')?.text ??
          detail?['modules']?[0]?['module_author']?['name'] ??
          '';

      // 动态详情
      Element opusDetail = appDom.querySelector('.opus-detail')!;
      // 发布时间
      String updateTime =
          opusDetail.querySelector('.opus-module-author__pub__text')!.text;
      //
      String opusContent =
          opusDetail.querySelector('.opus-module-content')!.innerHtml;
      String? test;
      try {
        test = opusDetail
            .querySelector('.horizontal-scroll-album__pic__img')!
            .innerHtml;
      } catch (_) {}

      int? commentId = initialCommentId;
      final Element? commentContainer =
          opusDetail.querySelector('.bili-comment-container');
      if (commentId == null && commentContainer != null) {
        commentId =
            _parseInt(commentContainer.className.split(' ')[1].split('-')[2]);
      }
      // List imgList = opusDetail.querySelectorAll('bili-album__preview__picture__img');
      return {
        'status': true,
        'avatar': avatar,
        'uname': uname,
        'updateTime': updateTime,
        'content': (test ?? '') + opusContent,
        'commentId': commentId
      };
    } catch (err) {
      Logutils.println('err: $err');
    }
  }

  // read
  static Future reqReadHtml(id, dynamicType) async {
    var response = await DioInstance.instance().get(
      path: "https://www.bilibili.com/$dynamicType/$id/",
      extra: {'ua': 'pc'},
    );
    Document rootTree = parse(response.data);
    Element body = rootTree.body!;
    Element appDom = body.querySelector('#app')!;
    Element authorHeader = appDom.querySelector('.up-left')!;
    // 头像
    // String avatar =
    //     authorHeader.querySelector('.bili-avatar-img')!.attributes['data-src']!;
    // print(avatar);
    // avatar = 'https:${avatar.split('@')[0]}';
    String uname = authorHeader.querySelector('.up-name')!.text.trim();
    // 动态详情
    Element opusDetail = appDom.querySelector('.article-content')!;
    // 发布时间
    // String updateTime =
    //     opusDetail.querySelector('.opus-module-author__pub__text')!.text;
    // print(updateTime);

    //
    String opusContent =
        opusDetail.querySelector('#read-article-holder')!.innerHtml;
    RegExp digitRegExp = RegExp(r'\d+');
    Iterable<Match> matches = digitRegExp.allMatches(id);
    String number = matches.first.group(0)!;
    return {
      'status': true,
      'avatar': '',
      'uname': uname,
      'updateTime': '',
      'content': opusContent,
      'commentId': int.parse(number)
    };
  }
}

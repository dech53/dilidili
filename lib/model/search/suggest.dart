import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchSuggestModel {
  SearchSuggestModel({
    this.tag,
    this.term,
  });

  List<SearchSuggestItem>? tag;
  String? term;

  SearchSuggestModel.fromJson(Map<String, dynamic> json) {
    tag = json['tag']
        .map<SearchSuggestItem>(
            (e) => SearchSuggestItem.fromJson(e, json['term']))
        .toList();
  }
}

class SearchSuggestItem {
  SearchSuggestItem({
    this.value,
    this.term,
    this.spid,
    this.textRich,
  });

  String? value;
  String? term;
  int? spid;
  Widget? textRich;

  SearchSuggestItem.fromJson(Map<String, dynamic> json, String inputTerm) {
    value = json['value'];
    term = json['term'];
    textRich = highlightText(json['name']);
  }
}

//匹配并构建高亮文本
Widget highlightText(String str) {
  RegExp regex = RegExp(r'<em class="suggest_high_light">(.*?)<\/em>');
  List<InlineSpan> children = [];
  Iterable<Match> matches = regex.allMatches(str);
  int currentIndex = 0;
  for (var match in matches) {
    String normalText = str.substring(currentIndex, match.start);
    String highlightedText = match.group(1)!;
    if (normalText.isNotEmpty) {
      children.add(TextSpan(
        text: normalText,
        style: DefaultTextStyle.of(Get.context!).style,
      ));
    }
    children.add(TextSpan(
      text: highlightedText,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(Get.context!).colorScheme.primary),
    ));
    currentIndex = match.end;
  }
  if (currentIndex < str.length) {
    String remainingText = str.substring(currentIndex);
    children.add(TextSpan(
      text: remainingText,
      style: DefaultTextStyle.of(Get.context!).style,
    ));
  }
  return Text.rich(TextSpan(children: children));
}

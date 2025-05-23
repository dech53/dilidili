class HotSearchModel {
  HotSearchModel({
    this.list,
  });

  List<HotSearchItem>? list;

  HotSearchModel.fromJson(Map<String, dynamic> json) {
    list = json['list']
        .map<HotSearchItem>((e) => HotSearchItem.fromJson(e))
        .toList();
  }
}

class HotSearchItem {
  HotSearchItem({
    this.keyword,
    this.showName,
    this.wordType,
    this.icon,
  });

  String? keyword;
  String? showName;
  int? wordType;
  String? icon;

  HotSearchItem.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    showName = json['show_name'];
    wordType = json['word_type'];
    icon = json['icon'];
  }
}

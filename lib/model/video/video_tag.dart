
class VideoTag {
  int? tagId;
  String? tagName;
  VideoTag({
    this.tagId,
    this.tagName,
  });

  VideoTag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag_id'] = tagId;
    data['tag_name'] = tagName;
    return data;
  }
}

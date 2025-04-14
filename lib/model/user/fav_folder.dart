import 'package:json_annotation/json_annotation.dart';
part 'fav_folder.g.dart';
@JsonSerializable()
class FavFolderData {
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "list")
  List<ListElement>? list;
  @JsonKey(name: "season")
  dynamic season;

  FavFolderData({
    this.count,
    this.list,
    this.season,
  });

  factory FavFolderData.fromJson(Map<String, dynamic> json) =>
      _$FavFolderDataFromJson(json);

  Map<String, dynamic> toJson() => _$FavFolderDataToJson(this);
}

@JsonSerializable()
class ListElement {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "fid")
  int? fid;
  @JsonKey(name: "mid")
  int? mid;
  @JsonKey(name: "attr")
  int? attr;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "fav_state")
  int? favState;
  @JsonKey(name: "media_count")
  int? mediaCount;

  ListElement({
    this.id,
    this.fid,
    this.mid,
    this.attr,
    this.title,
    this.favState,
    this.mediaCount,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      _$ListElementFromJson(json);

  Map<String, dynamic> toJson() => _$ListElementToJson(this);
}

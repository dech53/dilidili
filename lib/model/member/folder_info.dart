import 'package:json_annotation/json_annotation.dart';
part 'folder_info.g.dart';
@JsonSerializable()
class FolderInfo {
    @JsonKey(name: "count")
    int? count;
    @JsonKey(name: "list")
    List<FolderItem>? list;
    @JsonKey(name: "season")
    dynamic season;

    FolderInfo({
        this.count,
        this.list,
        this.season,
    });

    factory FolderInfo.fromJson(Map<String, dynamic> json) => _$FolderInfoFromJson(json);

    Map<String, dynamic> toJson() => _$FolderInfoToJson(this);
}

@JsonSerializable()
class FolderItem {
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

    FolderItem({
        this.id,
        this.fid,
        this.mid,
        this.attr,
        this.title,
        this.favState,
        this.mediaCount,
    });

    factory FolderItem.fromJson(Map<String, dynamic> json) => _$FolderItemFromJson(json);

    Map<String, dynamic> toJson() => _$FolderItemToJson(this);
}

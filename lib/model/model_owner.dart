import 'package:dilidili/model/model_video.dart';

class Owner implements BaseOwner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });

  @override
  int? mid;
  @override
  String? name;
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    final dynamic rawMid = json['mid'];
    mid = rawMid is int ? rawMid : int.tryParse(rawMid?.toString() ?? '');
    name = json['name'];
    face = json['face'];
  }

  Map<String, dynamic> toJson() => {
        'mid': mid,
        'name': name,
        'face': face,
      };
}

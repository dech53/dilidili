enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  failed,
}

extension DownloadStatusCode on DownloadStatus {
  String get code => name;

  static DownloadStatus fromCode(String? code) {
    return DownloadStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => DownloadStatus.pending,
    );
  }
}

extension DownloadStatusDesc on DownloadStatus {
  String get description {
    switch (this) {
      case DownloadStatus.pending:
        return '等待下载';
      case DownloadStatus.downloading:
        return '下载中';
      case DownloadStatus.paused:
        return '已暂停';
      case DownloadStatus.completed:
        return '已完成';
      case DownloadStatus.failed:
        return '下载失败';
    }
  }
}

class DownloadTask {
  DownloadTask({
    required this.id,
    required this.bvid,
    required this.cid,
    required this.quality,
    required this.qualityDescription,
    required this.sourceType,
    required this.createdAt,
    this.aid,
    this.title,
    this.cover,
    this.partTitle,
    this.videoCodec,
    this.videoCodecDescription,
    this.audioQuality,
    this.audioQualityDescription,
    this.duration,
    this.videoType,
    this.videoPath,
    this.audioPath,
    this.errorMessage,
    this.videoDownloadedBytes = 0,
    this.videoTotalBytes = 0,
    this.audioDownloadedBytes = 0,
    this.audioTotalBytes = 0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.status = DownloadStatus.pending,
  });

  final String id;
  final String bvid;
  final int cid;
  final int? aid;
  final String? title;
  final String? cover;
  final String? partTitle;
  final int quality;
  final String qualityDescription;
  final String? videoCodec;
  final String? videoCodecDescription;
  final int? audioQuality;
  final String? audioQualityDescription;
  final String sourceType;
  final int? duration;
  final String? videoType;
  String? videoPath;
  String? audioPath;
  String? errorMessage;
  int videoDownloadedBytes;
  int videoTotalBytes;
  int audioDownloadedBytes;
  int audioTotalBytes;
  int downloadedBytes;
  int totalBytes;
  DownloadStatus status;
  final DateTime createdAt;

  double get progress {
    if (totalBytes <= 0) {
      return 0;
    }
    return (downloadedBytes / totalBytes).clamp(0, 1).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bvid': bvid,
      'cid': cid,
      'aid': aid,
      'title': title,
      'cover': cover,
      'partTitle': partTitle,
      'quality': quality,
      'qualityDescription': qualityDescription,
      'videoCodec': videoCodec,
      'videoCodecDescription': videoCodecDescription,
      'audioQuality': audioQuality,
      'audioQualityDescription': audioQualityDescription,
      'sourceType': sourceType,
      'duration': duration,
      'videoType': videoType,
      'videoPath': videoPath,
      'audioPath': audioPath,
      'errorMessage': errorMessage,
      'videoDownloadedBytes': videoDownloadedBytes,
      'videoTotalBytes': videoTotalBytes,
      'audioDownloadedBytes': audioDownloadedBytes,
      'audioTotalBytes': audioTotalBytes,
      'downloadedBytes': downloadedBytes,
      'totalBytes': totalBytes,
      'status': status.code,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DownloadTask.fromJson(Map<dynamic, dynamic> json) {
    return DownloadTask(
      id: json['id'] as String,
      bvid: json['bvid'] as String,
      cid: _asInt(json['cid']) ?? 0,
      aid: _asInt(json['aid']),
      title: json['title'] as String?,
      cover: json['cover'] as String?,
      partTitle: json['partTitle'] as String?,
      quality: _asInt(json['quality']) ?? 0,
      qualityDescription: json['qualityDescription'] as String,
      videoCodec: json['videoCodec'] as String?,
      videoCodecDescription: json['videoCodecDescription'] as String?,
      audioQuality: _asInt(json['audioQuality']),
      audioQualityDescription: json['audioQualityDescription'] as String?,
      sourceType: json['sourceType'] as String,
      duration: _asInt(json['duration']),
      videoType: json['videoType'] as String?,
      videoPath: json['videoPath'] as String?,
      audioPath: json['audioPath'] as String?,
      errorMessage: json['errorMessage'] as String?,
      videoDownloadedBytes: _asInt(json['videoDownloadedBytes']) ?? 0,
      videoTotalBytes: _asInt(json['videoTotalBytes']) ?? 0,
      audioDownloadedBytes: _asInt(json['audioDownloadedBytes']) ?? 0,
      audioTotalBytes: _asInt(json['audioTotalBytes']) ?? 0,
      downloadedBytes: _asInt(json['downloadedBytes']) ?? 0,
      totalBytes: _asInt(json['totalBytes']) ?? 0,
      status: DownloadStatusCode.fromCode(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  void updateAggregateProgress() {
    downloadedBytes = videoDownloadedBytes + audioDownloadedBytes;
    totalBytes = videoTotalBytes + audioTotalBytes;
  }

  static int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}

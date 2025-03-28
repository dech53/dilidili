class NumUtils {
  static String int2time(int duration) {
    int hours = duration ~/ 3600;
    int remainingSeconds = duration % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;

    List<String> parts = [];
    if (hours > 0) {
      parts.add(hours.toString().padLeft(2, '0'));
    }
    parts.add(minutes.toString().padLeft(2, '0'));
    parts.add(seconds.toString().padLeft(2, '0'));

    return parts.join(":");
  }

  static String int2Num(int num) {
    if (num >= 100000000) {
      double value = num / 100000000;
      return '${value.toStringAsFixed(1)}亿';
    } else if (num >= 10000) {
      double value = num / 10000;
      return '${value.toStringAsFixed(1)}万';
    } else {
      return num.toString();
    }
  }

  static String int2Date(int timestamp) {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int timeDifference = currentTime - timestamp;

    if (timeDifference < 60) {
      return '$timeDifference秒前';
    } else if (timeDifference < 3600) {
      int minutes = (timeDifference / 60).floor();
      return '$minutes分钟前';
    } else if (timeDifference < 86400) {
      int hours = (timeDifference / 3600).floor();
      return '$hours小时前';
    } else {
      int days = (timeDifference / 86400).floor();
      return '$days天前';
    }
  }
}

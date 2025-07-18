class NumUtils {
  static String int2time(dynamic time) {
    // 1小时内
    if (time is String && time.contains(':')) {
      return time;
    }
    if (time < 3600) {
      if (time == 0) {
        return '00:00';
      }
      final int minute = time ~/ 60;
      final double res = time / 60;
      if (minute != res) {
        return '${minute < 10 ? '0$minute' : minute}:${(time - minute * 60) < 10 ? '0${(time - minute * 60)}' : (time - minute * 60)}';
      } else {
        return '$minute:00';
      }
    } else {
      final int hour = time ~/ 3600;
      final String hourStr = hour < 10 ? '0$hour' : hour.toString();
      var a = int2time(time - hour * 3600);
      return '$hourStr:$a';
    }
  }

  // 完全相对时间显示
  static String formatTimestampToRelativeTime(timeStamp) {
    var difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000));

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365}年前';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}个月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  static String int2Num(dynamic num) {
    if (num == null) {
      return '0';
    }
    if (num is String) {
      return num;
    }
    final String res = (num / 10000).toString();
    if (int.parse(res.split('.')[0]) >= 1) {
      return '${(num / 10000).toStringAsFixed(1)}万';
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

  static String dateFormat(timeStamp, {formatType = 'list'}) {
    if (timeStamp == 0 || timeStamp == null || timeStamp == '') {
      return '';
    }
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    int distance = (time - timeStamp).toInt();
    String currentYearStr = 'MM月DD日 hh:mm';
    String lastYearStr = 'YY年MM月DD日 hh:mm';
    if (formatType == 'detail') {
      currentYearStr = 'MM-DD hh:mm';
      lastYearStr = 'YY-MM-DD hh:mm';
      return CustomStamp_str(
          timestamp: timeStamp,
          date: lastYearStr,
          toInt: false,
          formatType: formatType);
    }
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return CustomStamp_str(
          timestamp: timeStamp,
          date: currentYearStr,
          toInt: false,
          formatType: formatType);
    } else {
      return CustomStamp_str(
          timestamp: timeStamp,
          date: lastYearStr,
          toInt: false,
          formatType: formatType);
    }
  }

  static String CustomStamp_str(
      {int? timestamp, String? date, bool toInt = true, String? formatType}) {
    timestamp ??= (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String YY = dateArr.split('-')[0];
    String MM = dateArr.split('-')[1];
    String DD = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mm = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    if (toInt) {
      MM = (int.parse(MM)).toString();
      DD = (int.parse(DD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (date == null) {
      return timeStr;
    }
    date = date
        .replaceAll('YY', YY)
        .replaceAll('MM', MM)
        .replaceAll('DD', DD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);
    if (int.parse(YY) == DateTime.now().year &&
        int.parse(MM) == DateTime.now().month) {
      if (int.parse(DD) == DateTime.now().day) {
        return '今天';
      }
    }
    return date;
  }
}

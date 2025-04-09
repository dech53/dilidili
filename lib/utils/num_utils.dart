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
      {int? timestamp,
      String? date, 
      bool toInt = true,
      String? formatType}) {
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

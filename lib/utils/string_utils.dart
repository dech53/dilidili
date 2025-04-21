import 'dart:math';

class StringUtils {
  static final Random random = Random();
  static String getTimeGreeting() {
    final DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour >= 6 && hour < 12) {
      return "早上好";
    } else if (hour >= 12 && hour < 18) {
      return "下午好";
    } else {
      return "晚上好";
    }
  }

  static String makeHeroTag(v) {
    return v.toString() + random.nextInt(9999).toString();
  }
}

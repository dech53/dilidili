class StringUtils {
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
}

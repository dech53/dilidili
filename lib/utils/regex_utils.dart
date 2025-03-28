class RegexUtils {
  static String extractWbiKey(String url) {
    final regExp = RegExp(r'(?<=wbi\/)[a-f0-9]{32}(?=\.png)');
    final match = regExp.firstMatch(url);
    return match?.group(0) ?? '';
  }
}

import 'package:dilidili/cache/shared_preferences_instance.dart';

class SPStorage {
  static late final String userID;
  static late final SharedPreferencesInstance prefs;
  static Future<void> init() async {
    prefs = await SharedPreferencesInstance.instance();
    userID = prefs.getString('DedeUserID') ?? '';
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static String userIdKey = "USERKEY";

  Future<void> saveUserId(String getUserId) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    await pres.setString(userIdKey, getUserId);
  }

  Future<String?> getUserId() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    return pres.getString(userIdKey);
  }

  Future<void> clearUserId() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    pres.remove("USERKEY");
  }

}

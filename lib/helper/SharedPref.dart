import 'package:shared_preferences/shared_preferences.dart';

class ProfilPreferences {
  static SharedPreferences? _prefs;

  static const _name = "status";
  static const _invite = "invite";

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future<bool> invite() async => _prefs!.getBool(_invite) ?? false;

  static Future<bool> status() async => _prefs!.getBool(_name) ?? false;

  static Future toggleInvite() async {
    await _prefs!.setBool(_invite, !(await invite()));
  }

  static Future falseInvite() async {
    await _prefs!.setBool(_invite, false);
  }

  static Future toggleStatus() async {
    await _prefs!.setBool(_name, !(await status()));
  }
}

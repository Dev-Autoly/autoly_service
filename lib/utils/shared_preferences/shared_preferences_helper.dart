import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) != null) {
      return json.decode(prefs.getString(key));
    } else {
      return null;
    }
  }

  static setVal(String key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  ///-----------------
  ///Save boolean values
  ///------------------
  static Future<bool> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getBool(key ?? false) : false;
  }

  static Future<bool> saveBoolean(
      String key, bool value, SharedPreferences prefs) {
    return prefs.setBool(key, value);
  }
}

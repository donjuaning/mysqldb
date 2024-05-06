/*
 * @Author: DonJuaning
 * @Date: 2024-04-29 10:23:23
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-01 10:55:24
 * @FilePath: /mysqldb/lib/perfence.dart
 * @Description: 
 */
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static initSP() async {
    prefs = await SharedPreferences.getInstance();
  }

  static save(String key, String value) {
    prefs?.setString(key, value);
  }

  static get(String key) {
    var p = prefs?.get(key);
    if (p != null) {
      return p;
    } else {
      return "0";
    }
  }

  static remove(String key) {
    prefs?.remove(key);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import 'setting_data_source.dart';

class SettingLocalDataSource implements SettingDataSource {
  SettingLocalDataSource();

  @override
  Future<Object?> getSetting(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  @override
  Future<bool> saveSetting(String key, Object? value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      return sharedPreferences.setBool(key, value);
    }
    if (value is double) {
      return sharedPreferences.setDouble(key, value);
    }
    if (value is int) {
      return sharedPreferences.setInt(key, value);
    }
    if (value is List<String>) {
      return sharedPreferences.setStringList(key, value);
    }
    if (value is String) {
      return sharedPreferences.setString(key, value.toString());
    }
    return false;
  }
}

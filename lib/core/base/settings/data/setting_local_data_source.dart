import 'package:shared_preferences/shared_preferences.dart';

import 'setting_data_source.dart';

class SettingLocalDataSource implements SettingDataSource {
  SettingLocalDataSource();

  @override
  Future<bool> getSetting(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? false;
  }

  @override
  Future<bool> saveSetting(String key, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, value);
  }
}

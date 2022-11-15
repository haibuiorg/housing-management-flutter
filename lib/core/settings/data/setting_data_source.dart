abstract class SettingDataSource {
  Future<bool> saveSetting(String key, bool value);
  Future<bool> getSetting(String key);
}

abstract class SettingDataSource {
  Future<bool> saveSetting(String key, Object? value);
  Future<Object?> getSetting(String key);
}

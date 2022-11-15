import '../../base/result.dart';

abstract class SettingRepository {
  Future<Result<bool>> saveSetting(String key, bool value);
  Future<Result<bool>> getSetting(String key);
}

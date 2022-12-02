import '../../base/result.dart';

abstract class SettingRepository {
  Future<Result<bool>> saveSetting(String key, Object? value);
  Future<Result<Object?>> getSetting(String key);
}

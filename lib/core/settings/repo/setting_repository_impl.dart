import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../../base/result.dart';
import '../data/setting_data_source.dart';
import 'setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingDataSource settingRemoteDataSource;

  SettingRepositoryImpl({required this.settingRemoteDataSource});

  @override
  Future<Result<bool>> getSetting(String key) async {
    try {
      final setting = await settingRemoteDataSource.getSetting(key);
      return ResultSuccess(setting);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> saveSetting(String key, bool value) async {
    try {
      final setting = await settingRemoteDataSource.saveSetting(key, value);
      return ResultSuccess(setting);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

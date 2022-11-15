import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repo/setting_repository.dart';

class GetSetting extends UseCase<bool, GetSettingParams> {
  final SettingRepository settingRepository;

  GetSetting({required this.settingRepository});
  @override
  Future<Result<bool>> call(GetSettingParams params) {
    return settingRepository.getSetting(
      params.key,
    );
  }
}

class GetSettingParams extends Equatable {
  final String key;

  const GetSettingParams({required this.key});

  @override
  List<Object?> get props => [key];
}

import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repo/setting_repository.dart';

class SaveSetting extends UseCase<Object, SaveSettingParams> {
  final SettingRepository settingRepository;

  SaveSetting({required this.settingRepository});
  @override
  Future<Result<Object>> call(SaveSettingParams params) {
    return settingRepository.saveSetting(params.key, params.value);
  }
}

class SaveSettingParams extends Equatable {
  final String key;
  final Object? value;

  const SaveSettingParams({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

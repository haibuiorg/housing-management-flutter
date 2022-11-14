import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/setting_state.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/settings/usecases/get_setting.dart';
import 'package:priorli/core/base/settings/usecases/save_setting.dart';
import 'package:priorli/core/base/settings/usecases/setting_constants.dart';

class SettingCubit extends Cubit<SettingState> {
  final GetSetting _getSetting;
  final SaveSetting _saveSetting;

  SettingCubit(this._getSetting, this._saveSetting)
      : super(const SettingState.initializing()) {
    _checkAppData();
  }

  Future<void> _checkAppData() async {
    final isDarkThemeResult =
        await _getSetting(const GetSettingParams(key: darkModeKey));
    final isDarkTheme =
        (isDarkThemeResult is ResultSuccess<bool>) && isDarkThemeResult.data;
    emit(state.copyWith(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light));
  }

  Future<void> switchTheme(bool isDark) async {
    final settingResult =
        await _saveSetting(SaveSettingParams(key: darkModeKey, value: isDark));
    final saveSuccess =
        (settingResult is ResultSuccess<bool>) && settingResult.data;
    emit(state.copyWith(
      brightness: (saveSuccess && isDark) ? Brightness.dark : Brightness.light,
    ));
  }
}

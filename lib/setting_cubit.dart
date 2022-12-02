import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/housing/entities/ui.dart';
import 'package:priorli/setting_state.dart';
import 'package:priorli/core/base/result.dart';

import 'core/settings/usecases/get_setting.dart';
import 'core/settings/usecases/save_setting.dart';
import 'core/settings/usecases/setting_constants.dart';

class SettingCubit extends Cubit<SettingState> {
  final GetSetting _getSetting;
  final SaveSetting _saveSetting;

  SettingCubit(this._getSetting, this._saveSetting)
      : super(SettingState.initializing()) {
    _checkAppData();
  }

  Future<void> _checkAppData() async {
    final isDarkThemeResult =
        await _getSetting(const GetSettingParams(key: darkModeKey));
    final isDarkTheme =
        (isDarkThemeResult is ResultSuccess) && isDarkThemeResult.data;
    final languageCodeResult =
        await _getSetting(const GetSettingParams(key: languageCode));
    final languageCodeData =
        (languageCodeResult is ResultSuccess && languageCodeResult.data != null)
            ? languageCodeResult.data.toString()
            : 'fi';
    emit(state.copyWith(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        languageCode: languageCodeData));
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

  Future<void> updateUIFromCompany(UI? ui) async {
    emit(state.copyWith(ui: ui));
  }

  void switchLanguage(String? value) async {
    final settingResult =
        await _saveSetting(SaveSettingParams(key: languageCode, value: value));
    final saveSuccess =
        (settingResult is ResultSuccess<bool>) && settingResult.data;
    if (saveSuccess) {
      emit(state.copyWith(languageCode: value));
    }
  }
}

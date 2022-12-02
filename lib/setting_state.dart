import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/ui.dart';

import 'core/utils/constants.dart';

class SettingState extends Equatable {
  final Brightness? brightness;
  final String? languageCode;
  final List<String>? appSupportLanguageCode;
  final UI? ui;

  const SettingState({
    this.brightness,
    this.languageCode,
    this.ui,
    this.appSupportLanguageCode,
  });
  factory SettingState.initializing() => const SettingState(
        brightness: Brightness.dark,
        languageCode: 'fi',
        ui: UI(seedColor: appSeedColor),
        appSupportLanguageCode: ['en', 'fi'],
      );

  SettingState copyWith({
    Brightness? brightness,
    String? languageCode,
    UI? ui,
    List<String>? appSupportLanguageCode,
  }) =>
      SettingState(
          brightness: brightness ?? this.brightness,
          languageCode: languageCode ?? this.languageCode,
          appSupportLanguageCode:
              appSupportLanguageCode ?? this.appSupportLanguageCode,
          ui: ui ?? this.ui);

  @override
  List<Object?> get props =>
      [brightness, languageCode, ui, appSupportLanguageCode];
}

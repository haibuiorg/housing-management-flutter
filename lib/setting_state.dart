import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/ui.dart';

import 'core/utils/constant.dart';

class SettingState extends Equatable {
  final Brightness brightness;
  final String languageCode;
  final UI ui;

  const SettingState(this.brightness, this.languageCode, this.ui);
  const SettingState.initializing()
      : this(Brightness.dark, 'en', const UI(seedColor: appSeedColor));

  SettingState copyWith({
    Brightness? brightness,
    String? languageCode,
    UI? ui,
  }) {
    return SettingState(brightness ?? this.brightness,
        languageCode ?? this.languageCode, ui ?? this.ui);
  }

  @override
  List<Object?> get props => [brightness, languageCode, ui];
}

import 'dart:ui';

import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  final Brightness brightness;
  final String languageCode;

  const SettingState(this.brightness, this.languageCode);
  const SettingState.initializing()
      : this(
          Brightness.dark,
          'en',
        );

  SettingState copyWith({
    Brightness? brightness,
    String? languageCode,
  }) {
    return SettingState(
      brightness ?? this.brightness,
      languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [brightness, languageCode];
}

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:priorli/core/country/entities/legal_document.dart';
import 'package:priorli/core/housing/entities/ui.dart';

import 'core/utils/constants.dart';

class SettingState extends Equatable {
  final Brightness? brightness;
  final String? languageCode;
  final List<String>? appSupportLanguageCode;
  final UI? ui;
  final bool useSystemColor;
  final List<LegalDocument>? legalDocuments;

  const SettingState({
    this.brightness,
    this.languageCode,
    this.ui,
    this.legalDocuments,
    this.useSystemColor = false,
    this.appSupportLanguageCode,
  });
  factory SettingState.initializing() => const SettingState(
        brightness: Brightness.dark,
        languageCode: 'fi',
        useSystemColor: false,
        ui: UI(seedColor: appSeedColor),
        appSupportLanguageCode: ['en', 'fi'],
        legalDocuments: [],
      );

  SettingState copyWith({
    Brightness? brightness,
    String? languageCode,
    bool? useSystemColor,
    UI? ui,
    List<String>? appSupportLanguageCode,
    List<LegalDocument>? legalDocuments,
  }) =>
      SettingState(
          useSystemColor: useSystemColor ?? this.useSystemColor,
          brightness: brightness ?? this.brightness,
          languageCode: languageCode ?? this.languageCode,
          appSupportLanguageCode:
              appSupportLanguageCode ?? this.appSupportLanguageCode,
          legalDocuments: legalDocuments ?? this.legalDocuments,
          ui: ui ?? this.ui);

  @override
  List<Object?> get props => [
        brightness,
        languageCode,
        ui,
        appSupportLanguageCode,
        useSystemColor,
        legalDocuments
      ];
}

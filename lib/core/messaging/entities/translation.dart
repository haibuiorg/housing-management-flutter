import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/models/translation_model.dart';

class Translation extends Equatable {
  final String languageCode;
  final String value;

  const Translation({required this.languageCode, required this.value});

  factory Translation.modelToEntity(TranslationModel messageModel) =>
      Translation(
          languageCode: messageModel.language_code, value: messageModel.value);

  @override
  List<Object?> get props => [languageCode, value];
}

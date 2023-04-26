import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/models/translated_message_model.dart';

class TranslatedMessage extends Equatable {
  final String languageCode;
  final String value;

  const TranslatedMessage({required this.languageCode, required this.value});

  factory TranslatedMessage.modelToEntity(
          TranslatedMessageModel messageModel) =>
      TranslatedMessage(
          languageCode: messageModel.language_code, value: messageModel.value);

  @override
  List<Object?> get props => [languageCode, value];
}

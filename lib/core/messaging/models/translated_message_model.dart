// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translated_message_model.g.dart';

@JsonSerializable()
class TranslatedMessageModel extends Equatable {
  final String language_code;
  final String value;

  const TranslatedMessageModel(
      {required this.language_code, required this.value});

  factory TranslatedMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TranslatedMessageModelFromJson(json);
  @override
  List<Object?> get props => [language_code, value];
}

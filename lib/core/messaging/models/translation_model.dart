// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translation_model.g.dart';

@JsonSerializable()
class TranslationModel extends Equatable {
  final String language_code;
  final String value;

  const TranslationModel({required this.language_code, required this.value});

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);
  @override
  List<Object?> get props => [language_code, value];
}

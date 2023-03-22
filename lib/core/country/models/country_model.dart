// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel extends Equatable {
  final String country_code;
  final String id;
  final String currency_code;
  final List<String> support_languages;
  final String support_phone_number;
  final String support_email;

  const CountryModel(
      {required this.country_code,
      required this.support_languages,
      required this.id,
      required this.support_phone_number,
      required this.currency_code,
      required this.support_email});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  @override
  List<Object?> get props => [
        country_code,
        currency_code,
        support_languages,
        id,
        support_phone_number,
        support_email,
      ];
}

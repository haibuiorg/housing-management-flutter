// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel extends Equatable {
  final String country_code;
  final String id;
  final String currency_code;

  const CountryModel(
      {required this.country_code,
      required this.id,
      required this.currency_code});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  @override
  List<Object?> get props => [country_code, currency_code, id];
}

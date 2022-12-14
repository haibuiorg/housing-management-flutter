import 'package:equatable/equatable.dart';

import '../models/country_model.dart';

class Country extends Equatable {
  final String countryCode;
  final String currencyCode;
  final String id;

  const Country(
      {required this.countryCode,
      required this.currencyCode,
      required this.id});
  factory Country.modelToEntity(CountryModel model) => Country(
      countryCode: model.country_code,
      currencyCode: model.currency_code,
      id: model.id);
  @override
  List<Object?> get props => [countryCode, currencyCode, id];
}

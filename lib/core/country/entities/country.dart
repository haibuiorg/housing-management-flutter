import 'package:equatable/equatable.dart';

import '../models/country_model.dart';

class Country extends Equatable {
  final String countryCode;
  final String currencyCode;
  final String id;
  final List<String> supportLanguages;
  final String supportPhoneNumber;
  final String supportEmail;

  const Country(
      {required this.countryCode,
      required this.supportLanguages,
      required this.currencyCode,
      required this.supportPhoneNumber,
      required this.supportEmail,
      required this.id});
  factory Country.modelToEntity(CountryModel model) => Country(
      countryCode: model.country_code,
      currencyCode: model.currency_code,
      supportPhoneNumber: model.support_phone_number,
      supportLanguages: model.support_languages,
      supportEmail: model.support_email,
      id: model.id);
  @override
  List<Object?> get props => [
        countryCode,
        currencyCode,
        id,
        supportLanguages,
        supportPhoneNumber,
        supportEmail
      ];
}

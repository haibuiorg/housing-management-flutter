import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/models/housing_company_model.dart';

class HousingCompany extends Equatable {
  final String id;
  final String streetAddress1;
  final String streetAddress2;
  final String postalCode;
  final String city;
  final String countryCode;
  final double lat;
  final double lng;
  final String name;

  const HousingCompany(
      {required this.id,
      required this.streetAddress1,
      required this.streetAddress2,
      required this.postalCode,
      required this.city,
      required this.countryCode,
      required this.lat,
      required this.lng,
      required this.name});

  factory HousingCompany.modelToEntity(
          HousingCompanyModel housingCompanyModel) =>
      HousingCompany(
          id: housingCompanyModel.id,
          streetAddress1: housingCompanyModel.streetAddress1,
          streetAddress2: housingCompanyModel.streetAddress2,
          postalCode: housingCompanyModel.postalCode,
          city: housingCompanyModel.city,
          countryCode: housingCompanyModel.countryCode,
          lat: housingCompanyModel.lat,
          lng: housingCompanyModel.lng,
          name: housingCompanyModel.name);

  @override
  List<Object?> get props => [
        id,
        streetAddress1,
        streetAddress2,
        postalCode,
        city,
        countryCode,
        lat,
        lng,
        name
      ];
}

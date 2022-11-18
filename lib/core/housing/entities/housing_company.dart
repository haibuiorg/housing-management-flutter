import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/ui.dart';
import 'package:priorli/core/housing/models/housing_company_model.dart';
import 'package:priorli/core/housing/models/ui_model.dart';
import 'package:priorli/core/utils/constant.dart';

class HousingCompany extends Equatable {
  final String id;
  final String streetAddress1;
  final String streetAddress2;
  final String postalCode;
  final String city;
  final String countryCode;
  final String currencyCode;
  final double lat;
  final double lng;
  final int apartmentCount;
  final String name;
  final String businessId;
  final UI ui;

  const HousingCompany(
      {required this.id,
      required this.businessId,
      required this.streetAddress1,
      required this.streetAddress2,
      required this.postalCode,
      required this.city,
      required this.countryCode,
      required this.lat,
      required this.lng,
      required this.name,
      required this.currencyCode,
      required this.ui,
      required this.apartmentCount});

  factory HousingCompany.modelToEntity(
          HousingCompanyModel housingCompanyModel) =>
      HousingCompany(
          ui: UI.modelToEntity(
              housingCompanyModel.ui ?? const UIModel(appSeedColor)),
          businessId: housingCompanyModel.businessId ?? '',
          currencyCode: housingCompanyModel.currencyCode ?? 'eur',
          apartmentCount: housingCompanyModel.apartmentCount ?? 0,
          id: housingCompanyModel.id ?? '',
          streetAddress1: housingCompanyModel.streetAddress1 ?? '',
          streetAddress2: housingCompanyModel.streetAddress2 ?? '',
          postalCode: housingCompanyModel.postalCode ?? '',
          city: housingCompanyModel.city ?? '',
          countryCode: housingCompanyModel.countryCode ?? 'fi',
          lat: housingCompanyModel.lat ?? 0.0,
          lng: housingCompanyModel.lng ?? 0.0,
          name: housingCompanyModel.name ?? '');
  HousingCompany copyWith(
          {String? streetAddress1,
          String? streetAddress2,
          String? postalCode,
          String? city,
          String? countryCode,
          double? lat,
          double? lng,
          String? businessId,
          UI? ui,
          String? name}) =>
      HousingCompany(
          id: id,
          ui: ui ?? this.ui,
          streetAddress1: streetAddress1 ?? this.streetAddress1,
          streetAddress2: streetAddress2 ?? this.streetAddress2,
          postalCode: postalCode ?? this.postalCode,
          city: city ?? this.city,
          countryCode: countryCode ?? this.postalCode,
          currencyCode: currencyCode,
          lat: lat ?? this.lat,
          lng: lng ?? this.lng,
          name: name ?? this.name,
          businessId: businessId ?? this.businessId,
          apartmentCount: apartmentCount);

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
        name,
        apartmentCount
      ];
}

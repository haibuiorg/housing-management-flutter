import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/ui.dart';
import 'package:priorli/core/housing/models/housing_company_model.dart';

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
  final UI? ui;
  final bool isDeleted;
  final double vat;
  final String logoUrl;
  final String coverImageUrl;
  final bool isUserOwner;
  final bool isUserManager;

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
      required this.isDeleted,
      required this.currencyCode,
      required this.isUserManager,
      required this.isUserOwner,
      this.ui,
      required this.vat,
      required this.logoUrl,
      required this.coverImageUrl,
      required this.apartmentCount});

  factory HousingCompany.modelToEntity(
          HousingCompanyModel housingCompanyModel) =>
      HousingCompany(
          ui: UI.modelToEntity(housingCompanyModel.ui),
          businessId: housingCompanyModel.businessId ?? '',
          isDeleted: housingCompanyModel.isDeleted ?? false,
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
          name: housingCompanyModel.name ?? '',
          logoUrl: housingCompanyModel.logoUrl ?? '',
          isUserManager: housingCompanyModel.is_user_manager == true,
          isUserOwner: housingCompanyModel.is_user_owner == true,
          coverImageUrl: housingCompanyModel.coverImageUrl ?? '',
          vat: housingCompanyModel.vat ?? 0);
  HousingCompany copyWith(
          {String? streetAddress1,
          String? streetAddress2,
          String? postalCode,
          String? city,
          String? countryCode,
          double? lat,
          double? lng,
          String? businessId,
          bool? isDeleted,
          bool? isUserOwner,
          bool? isUserManager,
          UI? ui,
          String? name,
          String? logoUrl,
          String? coverImageUrl,
          double? vat}) =>
      HousingCompany(
          id: id,
          isUserManager: isUserManager ?? this.isUserManager,
          isUserOwner: isUserOwner ?? this.isUserOwner,
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
          isDeleted: isDeleted ?? this.isDeleted,
          businessId: businessId ?? this.businessId,
          vat: vat ?? this.vat,
          coverImageUrl: coverImageUrl ?? this.coverImageUrl,
          logoUrl: logoUrl ?? this.logoUrl,
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
        isUserManager,
        isUserOwner,
        lng,
        name,
        apartmentCount,
        isDeleted,
        logoUrl,
        coverImageUrl,
        vat,
        ui,
        businessId,
        currencyCode,
      ];
}

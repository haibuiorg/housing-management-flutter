import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ui_model.dart';

part 'housing_company_model.g.dart';

@JsonSerializable()
class HousingCompanyModel extends Equatable {
  final String? id;
  @JsonKey(name: 'street_address_1')
  final String? streetAddress1;
  @JsonKey(name: 'street_address_2')
  final String? streetAddress2;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final String? city;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @JsonKey(name: 'currency_code')
  final String? currencyCode;
  final double? lat;
  final double? lng;
  final String? name;
  @JsonKey(name: 'apartment_count')
  final int? apartmentCount;
  @JsonKey(name: 'business_id')
  final String? businessId;
  final UIModel? ui;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;
  final double? vat;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;

  const HousingCompanyModel(
      this.id,
      this.streetAddress1,
      this.streetAddress2,
      this.postalCode,
      this.city,
      this.countryCode,
      this.lat,
      this.lng,
      this.name,
      this.apartmentCount,
      this.currencyCode,
      this.businessId,
      this.isDeleted,
      this.vat,
      this.logoUrl,
      this.coverImageUrl,
      this.ui);

  factory HousingCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$HousingCompanyModelFromJson(json);

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
        apartmentCount,
        currencyCode,
        businessId,
        isDeleted,
        vat,
        ui,
        logoUrl,
        coverImageUrl
      ];
}

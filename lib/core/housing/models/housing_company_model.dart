import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'housing_company_model.g.dart';

@JsonSerializable()
class HousingCompanyModel extends Equatable {
  final String id;
  @JsonKey(name: 'street_address_1')
  final String? streetAddress1;
  @JsonKey(name: 'street_address_2')
  final String? streetAddress2;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final String? city;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  final double? lat;
  final double? lng;
  final String? name;

  const HousingCompanyModel(
      this.id,
      this.streetAddress1,
      this.streetAddress2,
      this.postalCode,
      this.city,
      this.countryCode,
      this.lat,
      this.lng,
      this.name);

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
        name
      ];
}

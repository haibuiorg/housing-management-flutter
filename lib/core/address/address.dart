import 'package:equatable/equatable.dart';
import 'package:priorli/core/address/address_model.dart';

class Address extends Equatable {
  final String? streetAddress1;
  final String? streetAddress2;
  final String? postalCode;
  final String id;
  final String? countryCode;
  final String? city;

  const Address(
      {this.streetAddress1,
      this.streetAddress2,
      this.postalCode,
      required this.id,
      this.countryCode,
      this.city});

  factory Address.modelToEntity(AddressModel model) => Address(
      id: model.id,
      streetAddress1: model.street_address_1,
      streetAddress2: model.street_address_2,
      postalCode: model.postal_code,
      city: model.city,
      countryCode: model.country_code);

  @override
  List<Object?> get props =>
      [streetAddress1, streetAddress2, id, postalCode, city, countryCode];
}

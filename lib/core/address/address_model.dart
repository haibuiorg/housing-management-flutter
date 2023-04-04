// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends Equatable {
  /*
   street_address_1?: string,
    street_address_2?: string,
    postal_code?: string,
    city?: string,
    country_code?: string,
    id: string,
  */
  final String? street_address_1;
  final String? street_address_2;
  final String? postal_code;
  final String id;
  final String? country_code;
  final String? city;
  final String owner_type;
  final String owner_id;
  final String? address_type;

  const AddressModel(
      {this.street_address_1,
      this.street_address_2,
      this.postal_code,
      required this.id,
      required this.owner_type,
      required this.owner_id,
      this.address_type,
      this.city,
      this.country_code});

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  @override
  List<Object?> get props => [
        street_address_1,
        street_address_2,
        postal_code,
        id,
        country_code,
        city,
        owner_type,
        owner_id,
        address_type
      ];
}

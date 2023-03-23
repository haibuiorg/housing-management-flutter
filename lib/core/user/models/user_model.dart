import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/address/address_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  final String phone;
  final String email;
  final List<dynamic>? roles;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'avatar_url')
  final dynamic avatarUrl;
  @JsonKey(name: 'email_verified')
  final bool? emailVerified;
  final List<AddressModel>? addresses;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  final List<String>? apartments;

  const UserModel(
      {required this.userId,
      required this.phone,
      required this.email,
      this.apartments,
      this.roles,
      this.addresses,
      required this.firstName,
      required this.lastName,
      this.avatarUrl,
      this.emailVerified,
      this.countryCode});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
        userId,
        phone,
        email,
        roles,
        firstName,
        apartments,
        lastName,
        avatarUrl,
        addresses,
        countryCode,
        emailVerified
      ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['user_id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      apartments: (json['apartments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      roles: json['roles'] as List<dynamic>?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'],
      emailVerified: json['email_verified'] as bool?,
      countryCode: json['country_code'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.userId,
      'phone': instance.phone,
      'email': instance.email,
      'roles': instance.roles,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'email_verified': instance.emailVerified,
      'addresses': instance.addresses,
      'country_code': instance.countryCode,
      'apartments': instance.apartments,
    };

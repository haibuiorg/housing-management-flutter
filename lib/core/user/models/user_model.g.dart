// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['user_id'] as String,
      json['phone'] as String,
      json['email'] as String,
      (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      json['first_name'] as String,
      json['last_name'] as String,
      json['avatar_url'] as String?,
      json['email_verified'] as bool?,
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
    };

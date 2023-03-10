// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_lead_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactLeadModel _$ContactLeadModelFromJson(Map<String, dynamic> json) =>
    ContactLeadModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      message: json['message'] as String?,
      created_on: json['created_on'] as int?,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ContactLeadModelToJson(ContactLeadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'message': instance.message,
      'created_on': instance.created_on,
      'status': instance.status,
      'type': instance.type,
    };

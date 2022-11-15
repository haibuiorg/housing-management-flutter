// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentInvitationModel _$ApartmentInvitationModelFromJson(
        Map<String, dynamic> json) =>
    ApartmentInvitationModel(
      invitationCode: json['invitation_code'] as String,
      id: json['id'] as String,
      isValid: json['is_valid'] as int,
      validUntil: json['valid_until'] as int,
      apartmentId: json['apartment_id'] as String,
      housingCompanyId: json['housing_company_id'] as String,
      claimedBy: (json['claimed_by'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ApartmentInvitationModelToJson(
        ApartmentInvitationModel instance) =>
    <String, dynamic>{
      'invitation_code': instance.invitationCode,
      'id': instance.id,
      'is_valid': instance.isValid,
      'valid_until': instance.validUntil,
      'apartment_id': instance.apartmentId,
      'housing_company_id': instance.housingCompanyId,
      'claimed_by': instance.claimedBy,
    };

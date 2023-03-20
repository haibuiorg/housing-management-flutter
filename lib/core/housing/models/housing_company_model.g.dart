// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'housing_company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HousingCompanyModel _$HousingCompanyModelFromJson(Map<String, dynamic> json) =>
    HousingCompanyModel(
      json['id'] as String?,
      json['street_address_1'] as String?,
      json['street_address_2'] as String?,
      (json['credit_amount'] as num?)?.toDouble(),
      json['postal_code'] as String?,
      json['city'] as String?,
      json['country_code'] as String?,
      (json['lat'] as num?)?.toDouble(),
      (json['lng'] as num?)?.toDouble(),
      json['name'] as String?,
      json['apartment_count'] as int?,
      json['currency_code'] as String?,
      json['business_id'] as String?,
      json['is_deleted'] as bool?,
      (json['vat'] as num?)?.toDouble(),
      json['logo_url'] as String?,
      json['cover_image_url'] as String?,
      json['is_user_manager'] as bool?,
      json['is_user_owner'] as bool?,
      json['ui'] == null
          ? null
          : UIModel.fromJson(json['ui'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HousingCompanyModelToJson(
        HousingCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'street_address_1': instance.streetAddress1,
      'street_address_2': instance.streetAddress2,
      'postal_code': instance.postalCode,
      'city': instance.city,
      'country_code': instance.countryCode,
      'currency_code': instance.currencyCode,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'apartment_count': instance.apartmentCount,
      'business_id': instance.businessId,
      'ui': instance.ui,
      'is_deleted': instance.isDeleted,
      'vat': instance.vat,
      'logo_url': instance.logoUrl,
      'cover_image_url': instance.coverImageUrl,
      'is_user_owner': instance.is_user_owner,
      'is_user_manager': instance.is_user_manager,
      'credit_amount': instance.credit_amount,
    };

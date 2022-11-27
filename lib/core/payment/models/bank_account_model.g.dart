// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccountModel _$BankAccountModelFromJson(Map<String, dynamic> json) =>
    BankAccountModel(
      json['swift'] as String?,
      json['bank_account_number'] as String?,
      json['id'] as String?,
      json['is_deleted'] as bool?,
      json['housing_company_id'] as String?,
    );

Map<String, dynamic> _$BankAccountModelToJson(BankAccountModel instance) =>
    <String, dynamic>{
      'swift': instance.swift,
      'bank_account_number': instance.bankAccountNumber,
      'id': instance.id,
      'is_deleted': instance.isDeleted,
      'housing_company_id': instance.housingCompanyId,
    };

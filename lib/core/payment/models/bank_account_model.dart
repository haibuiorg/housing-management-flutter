import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_account_model.g.dart';

@JsonSerializable()
class BankAccountModel extends Equatable {
  final String? swift;
  @JsonKey(name: 'bank_account_number')
  final String? bankAccountNumber;
  final String? id;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;
  @JsonKey(name: 'housing_company_id')
  final String? housingCompanyId;

  const BankAccountModel(this.swift, this.bankAccountNumber, this.id,
      this.isDeleted, this.housingCompanyId);

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BankAccountModelFromJson(json);

  @override
  List<Object?> get props =>
      [swift, bankAccountNumber, id, isDeleted, housingCompanyId];
}

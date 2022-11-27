import 'package:equatable/equatable.dart';

import '../models/bank_account_model.dart';

class BankAccount extends Equatable {
  final String swift;
  final String bankAccountNumber;
  final String id;
  final bool isDeleted;
  final String housingCompanyId;

  const BankAccount(
      {required this.swift,
      required this.bankAccountNumber,
      required this.id,
      required this.isDeleted,
      required this.housingCompanyId});

  factory BankAccount.modelToEntity(BankAccountModel model) => BankAccount(
      swift: model.swift ?? '',
      bankAccountNumber: model.bankAccountNumber ?? '',
      id: model.id ?? '',
      housingCompanyId: model.housingCompanyId ?? '',
      isDeleted: model.isDeleted ?? true);

  @override
  List<Object?> get props =>
      [swift, bankAccountNumber, id, isDeleted, housingCompanyId];
}

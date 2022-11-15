import 'package:equatable/equatable.dart';

class BankAccount extends Equatable {
  final String swift;
  final String bankAccountNumber;
  final String id;
  final bool isActive;

  const BankAccount(this.swift, this.bankAccountNumber, this.id, this.isActive);

  @override
  List<Object?> get props => [swift, bankAccountNumber];
}

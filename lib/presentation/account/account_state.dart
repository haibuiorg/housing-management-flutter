import 'package:equatable/equatable.dart';
import 'package:priorli/core/country/entities/legal_document.dart';

import '../../core/user/entities/user.dart';

class AccountState extends Equatable {
  final User? user;
  final User? pendingUser;
  final List<LegalDocument>? legalDocuments;

  const AccountState({this.user, this.pendingUser, this.legalDocuments});

  AccountState copyWith(
          {User? user,
          User? pendingUser,
          List<LegalDocument>? legalDocuments}) =>
      AccountState(
          user: user ?? this.user,
          legalDocuments: legalDocuments ?? this.legalDocuments,
          pendingUser: pendingUser ?? this.pendingUser);

  @override
  List<Object?> get props => [user, pendingUser, legalDocuments];
}

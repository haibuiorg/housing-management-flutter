import 'package:equatable/equatable.dart';

import '../../core/user/entities/user.dart';

class AccountState extends Equatable {
  final User? user;
  final User? pendingUser;

  const AccountState({this.user, this.pendingUser});

  AccountState copyWith({User? user, User? pendingUser}) => AccountState(
      user: user ?? this.user, pendingUser: pendingUser ?? this.pendingUser);

  @override
  List<Object?> get props => [user, pendingUser];
}

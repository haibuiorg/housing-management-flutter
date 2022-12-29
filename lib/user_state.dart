import 'package:equatable/equatable.dart';
import 'package:priorli/core/user/entities/user.dart';

class UserState extends Equatable {
  final User? user;

  const UserState({this.user});

  @override
  List<Object?> get props => [user];

  UserState copyWith({User? user}) => UserState(user: user ?? this.user);
}

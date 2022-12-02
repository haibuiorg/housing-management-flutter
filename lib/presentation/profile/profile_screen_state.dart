
import 'package:equatable/equatable.dart';
import 'package:priorli/core/user/entities/user.dart';

class ProfileScreenState extends Equatable {
  final User? user;

  const ProfileScreenState({this.user});

  @override
  List<Object?> get props => [user];

  ProfileScreenState copyWith({User? user}) =>
      ProfileScreenState(user: user ?? this.user);
}

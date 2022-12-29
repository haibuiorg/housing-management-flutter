import 'package:equatable/equatable.dart';

import '../../core/user/entities/user.dart';

class MainState extends Equatable {
  final User? user;
  final bool? isAdmin;
  final bool isInitializing;

  const MainState({this.user, this.isAdmin, this.isInitializing = true});

  MainState copyWith({User? user, bool? isAdmin, bool? isInitializing}) =>
      MainState(
          user: user ?? this.user,
          isAdmin: isAdmin ?? this.isAdmin,
          isInitializing: isInitializing ?? this.isInitializing);

  @override
  List<Object?> get props => [user, isAdmin, isInitializing];
}

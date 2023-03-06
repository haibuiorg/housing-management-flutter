import 'package:equatable/equatable.dart';

import '../../core/user/entities/user.dart';

class MainState extends Equatable {
  final User? user;
  final bool? isAdmin;
  final bool isInitializing;
  final int? selectedTabIndex;

  const MainState(
      {this.user,
      this.isAdmin,
      this.isInitializing = true,
      this.selectedTabIndex});

  MainState copyWith(
          {User? user,
          bool? isAdmin,
          bool? isInitializing,
          int? selectedTabIndex}) =>
      MainState(
          selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
          user: user ?? this.user,
          isAdmin: isAdmin ?? this.isAdmin,
          isInitializing: isInitializing ?? this.isInitializing);

  @override
  List<Object?> get props => [user, isAdmin, isInitializing, selectedTabIndex];
}

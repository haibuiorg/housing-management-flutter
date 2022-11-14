import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoggedIn;
  final bool isEmailVerified;

  const AuthState(
    this.isLoggedIn,
    this.isEmailVerified,
  );
  const AuthState.initializing() : this(false, false);

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isEmailVerified,
  }) {
    return AuthState(
        isLoggedIn ?? this.isLoggedIn, isEmailVerified ?? this.isEmailVerified);
  }

  @override
  List<Object?> get props => [isLoggedIn, isEmailVerified];
}

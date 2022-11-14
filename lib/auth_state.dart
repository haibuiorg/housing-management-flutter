import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoggedIn;

  const AuthState(
    this.isLoggedIn,
  );
  const AuthState.initializing() : this(false);

  AuthState copyWith({
    bool? isLoggedIn,
  }) {
    return AuthState(
      isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [isLoggedIn];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import 'auth_state.dart';
import 'core/auth/usecases/is_email_verified.dart';
import 'core/auth/usecases/is_logged_in.dart';
import 'core/auth/usecases/log_out.dart';
import 'core/auth/usecases/login_email_password.dart';
import 'core/user/entities/user.dart';
import 'core/user/usecases/create_user.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsLoggedIn _isLoggedIn;
  final LoginEmailPassword _loginEmailPassword;
  final LogOut _logOut;
  final CreateUser _createUser;
  final IsEmailVerified _emailVerified;

  AuthCubit(
    this._isLoggedIn,
    this._loginEmailPassword,
    this._logOut,
    this._createUser,
    this._emailVerified,
  ) : super(const AuthState.initializing()) {
    _checkAppData();
  }

  Future<bool> _checkLoggedInData() async {
    final loginResult = await _isLoggedIn(NoParams());
    final isLoggedIn = (loginResult is ResultSuccess<bool>) && loginResult.data;
    return isLoggedIn;
  }

  Future<bool> _checkEmailVerifiedData() async {
    final isEmailVerifiedResult = await _emailVerified(NoParams());
    final isVerified = (isEmailVerifiedResult is ResultSuccess<bool>) &&
        isEmailVerifiedResult.data;
    return isVerified;
  }

  Future<void> _checkAppData() async {
    final isLoggedIn = await _checkLoggedInData();
    final isEmailVerified = await _checkEmailVerifiedData();
    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
      isEmailVerified: isEmailVerified,
    ));
  }

  Future<void> logIn({required String email, required String password}) async {
    final loginResult = await _loginEmailPassword(
        LoginEmailPasswordParams(email: email, password: password));
    final isLoggedIn = (loginResult is ResultSuccess<bool>) && loginResult.data;
    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
    ));
  }

  Future<void> logOut() async {
    final logOutResult = await _logOut(NoParams());
    final isLoggedIn =
        !((logOutResult is ResultSuccess<bool>) && logOutResult.data);
    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
    ));
  }

  Future<void> createUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required String password}) async {
    final createUserResult = await _createUser(CreateUserParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password));
    if (createUserResult is ResultSuccess<User>) {
      await logIn(email: createUserResult.data.email, password: password);
    }
  }
}

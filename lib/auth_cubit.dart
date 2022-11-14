import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/auth/usecases/is_logged_in.dart';
import 'package:priorli/core/base/auth/usecases/log_out.dart';
import 'package:priorli/core/base/auth/usecases/login_email_password.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsLoggedIn _isLoggedIn;
  final LoginEmailPassword _loginEmailPassword;
  final LogOut _logOut;

  AuthCubit(
    this._isLoggedIn,
    this._loginEmailPassword,
    this._logOut,
  ) : super(const AuthState.initializing()) {
    _checkAppData();
  }

  Future<bool> checkLoggedInData() async {
    final loginResult = await _isLoggedIn(NoParams());
    final isLoggedIn = (loginResult is ResultSuccess<bool>) && loginResult.data;
    return isLoggedIn;
  }

  Future<void> _checkAppData() async {
    final isLoggedIn = await checkLoggedInData();

    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
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
}

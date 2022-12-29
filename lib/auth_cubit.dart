import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/auth/usecases/change_password.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/usecases/delete_user_notification_token.dart';
import 'package:priorli/core/user/usecases/update_user_notification_token.dart';

import 'auth_state.dart';
import 'core/auth/usecases/is_email_verified.dart';
import 'core/auth/usecases/is_logged_in.dart';
import 'core/auth/usecases/log_out.dart';
import 'core/auth/usecases/login_email_password.dart';
import 'core/user/entities/user.dart';
import 'core/user/usecases/create_user.dart';
import 'core/user/usecases/register_with_code.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsLoggedIn _isLoggedIn;
  final LoginEmailPassword _loginEmailPassword;
  final LogOut _logOut;
  final CreateUser _createUser;
  final IsEmailVerified _emailVerified;
  final ChangePassword _changePassword;
  final RegisterWithCode _registerWithCode;
  final UpdateUserNotificationToken _updateUserNotificationToken;
  final DeleteUserNotificationToken _deleteUserNotificationToken;

  AuthCubit(
    this._isLoggedIn,
    this._loginEmailPassword,
    this._logOut,
    this._createUser,
    this._emailVerified,
    this._updateUserNotificationToken,
    this._deleteUserNotificationToken,
    this._changePassword,
    this._registerWithCode,
  ) : super(const AuthState.initializing()) {
    _checkAppData();
    _checkNotificationToken();
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
    if (isLoggedIn) {
      _checkNotificationToken();
    }
    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
    ));
  }

  Future<void> logOut() async {
    await deleteNotificationToken();
    final logOutResult = await _logOut(NoParams());
    final isLoggedIn =
        !((logOutResult is ResultSuccess<bool>) && logOutResult.data);
    emit(state.copyWith(
      isLoggedIn: isLoggedIn,
    ));
  }

  Future<void> deleteNotificationToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await _deleteUserNotificationToken(
        UpdateUserNotificationTokenParams(notificationToken: token ?? ''));
    await FirebaseMessaging.instance.deleteToken();
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

  Future<void> _checkNotificationToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        return;
      }
      _updateUserNotificationToken(
          UpdateUserNotificationTokenParams(notificationToken: token));
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) => {
            _updateUserNotificationToken(
                UpdateUserNotificationTokenParams(notificationToken: newToken))
          });
    } catch (error) {}
  }

  Future<void> changePassword(
      {required String oldPassword,
      required String newPassword,
      required Null Function() onError,
      required Null Function() onSuccessful}) async {
    final changePasswordResult = await _changePassword(ChangePasswordParams(
        oldPassword: oldPassword, newPassword: newPassword));
    if (changePasswordResult is ResultSuccess<bool> &&
        changePasswordResult.data) {
      onSuccessful();
      return;
    }
    onError();
  }

  Future<void> registerWithCode(
      {String? email,
      String? companyId,
      String? code,
      String? password}) async {
    final registerWithCodeResult = await _registerWithCode(
        RegisterWithCodeParams(
            code: code ?? '',
            companyId: companyId ?? '',
            email: email ?? '',
            password: password ?? ''));
    if (registerWithCodeResult is ResultSuccess<User>) {
      await logIn(
          email: registerWithCodeResult.data.email, password: password ?? '');
    }
  }
}

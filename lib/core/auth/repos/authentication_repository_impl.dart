import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../../base/result.dart';
import '../data/authentication_data_source.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDataSource authenticationDataSource;

  AuthenticationRepositoryImpl({required this.authenticationDataSource});

  @override
  Future<bool> isAuthenticated() async {
    return await authenticationDataSource.isAuthenticated();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await authenticationDataSource.isLoggedIn();
  }

  @override
  Future<bool> loginWithEmailPassword(
      {required String email, required String password}) async {
    return await authenticationDataSource.loginWithEmailPassword(
        email: email, password: password);
  }

  @override
  Future<bool> logOut() {
    return authenticationDataSource.logOut();
  }

  @override
  Future<String?> getToken() {
    return authenticationDataSource.getToken();
  }

  @override
  Future<Result<bool>> resetPassword({required String email}) async {
    try {
      final passwordResult =
          await authenticationDataSource.resetPassword(email: email);
      return ResultSuccess(passwordResult);
    } on ServerException catch (error) {
      return ResultFailure(
          ServerFailure(serverMessage: error.serverMessage, code: error.code));
    }
  }

  @override
  Future<Result<bool>> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final passwordResult = await authenticationDataSource.changePassword(
          oldPassword: oldPassword, newPassword: newPassword);
      return ResultSuccess(passwordResult);
    } on ServerException catch (error) {
      return ResultFailure(
          ServerFailure(serverMessage: error.serverMessage, code: error.code));
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    return await authenticationDataSource.isEmailVerified();
  }
}

import '../../base/result.dart';

abstract class AuthenticationRepository {
  Future<bool> loginWithEmailPassword(
      {required String email, required String password});
  Future<bool> loginWithToken({required String token});
  Future<bool> isAuthenticated();
  Future<bool> isLoggedIn();
  Future<bool> isEmailVerified();
  Future<bool> logOut();
  Future<String?> getToken();
  Future<Result<bool>> resetPassword({required String email});
  Future<Result<bool>> changePassword(
      {required String oldPassword, required String newPassword});
}

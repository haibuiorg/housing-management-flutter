abstract class AuthenticationDataSource {
  Future<bool> isAuthenticated();
  Future<bool> isLoggedIn();
  Future<bool> loginWithEmailPassword(
      {required String email, required String password});
  Future<bool> logOut();
  Future<String?> getToken();
  Future<bool> resetPassword({required String email});
  Future<bool> changePassword(
      {required String oldPassword, required String newPassword});
}

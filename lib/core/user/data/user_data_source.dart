import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserInfo();
  Future<UserModel> updateUserInfo(
      {String? fistName,
      String? lastName,
      String? phone,
      String? avatarStorageLocation});
  Future<UserModel> updateNotificationToken(
      {required String notificationToken});
  Future<bool> deleteNotificationToken({required String notificationToken});
  Future<UserModel> register({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
  });
  Future<UserModel> registerWithCode({
    required String email,
    required String password,
    required String code,
  });
}

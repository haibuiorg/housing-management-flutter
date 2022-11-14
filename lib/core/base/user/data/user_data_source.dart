import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserInfo();
  Future<UserModel> updateUserInfo(
      {required String fistName,
      required String lastName,
      required String phone});
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
}

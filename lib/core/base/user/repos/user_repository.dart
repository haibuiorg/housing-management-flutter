import '../../result.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Result<User>> getUserInfo();
  Future<Result<User>> updateUserInfo(
      {required String fistName,
      required String lastName,
      required String phone});
  Future<Result<User>> updateUserNotificationToken(
      {required String notificationToken});
  Future<Result<bool>> deleteNotificationToken(
      {required String notificationToken});
  Future<Result<User>> register({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
  });
}

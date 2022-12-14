import '../../base/result.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Result<User>> getUserInfo();
  Future<Result<User>> updateUserInfo(
      {String? fistName,
      String? lastName,
      String? phone,
      String? avatarStorageLocation});
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
  Future<Result<User>> registerWithCode({
    required String email,
    required String password,
    required String code,
    required String companyId,
  });
}

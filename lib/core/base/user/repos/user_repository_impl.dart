import '../../exceptions.dart';
import '../../failure.dart';
import '../../result.dart';
import '../data/user_data_source.dart';
import '../entities/user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<Result<User>> getUserInfo() async {
    try {
      final userModel = await userRemoteDataSource.getUserInfo();
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> updateUserInfo(
      {required String fistName,
      required String lastName,
      required String phone}) async {
    try {
      final userModel = await userRemoteDataSource.updateUserInfo(
          fistName: fistName, lastName: lastName, phone: phone);
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> updateUserNotificationToken(
      {required String notificationToken}) async {
    try {
      final userModel = await userRemoteDataSource.updateNotificationToken(
          notificationToken: notificationToken);
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> deleteNotificationToken(
      {required String notificationToken}) async {
    try {
      final result = await userRemoteDataSource.deleteNotificationToken(
          notificationToken: notificationToken);
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userModel = await userRemoteDataSource.register(
        email: email,
        password: password,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
      );
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

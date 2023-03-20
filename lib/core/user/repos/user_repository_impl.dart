import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../../base/result.dart';
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
      {String? fistName,
      String? lastName,
      String? phone,
      String? avatarStorageLocation}) async {
    try {
      final userModel = await userRemoteDataSource.updateUserInfo(
          fistName: fistName,
          lastName: lastName,
          phone: phone,
          avatarStorageLocation: avatarStorageLocation);
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

  @override
  Future<Result<User>> registerWithCode({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      final userModel = await userRemoteDataSource.registerWithCode(
        email: email,
        password: password,
        code: code,
      );
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

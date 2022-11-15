import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/user.dart';
import '../repos/user_repository.dart';

class UpdateUserInfo extends UseCase<User, UpdateUserInfoParams> {
  final UserRepository userRepository;

  UpdateUserInfo({required this.userRepository});

  @override
  Future<Result<User>> call(UpdateUserInfoParams params) async {
    return userRepository.updateUserInfo(
        fistName: params.firstName,
        lastName: params.lastName,
        phone: params.phone);
  }
}

class UpdateUserInfoParams extends Equatable {
  final String phone;
  final String lastName;
  final String firstName;

  const UpdateUserInfoParams(
      {required this.phone, required this.lastName, required this.firstName});

  @override
  List<Object?> get props => [phone, lastName, firstName];
}

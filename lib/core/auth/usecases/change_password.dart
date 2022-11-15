import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class ChangePassword extends UseCase<bool, ChangePasswordParams> {
  final AuthenticationRepository authenticationRepository;

  ChangePassword({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(ChangePasswordParams params) async {
    return authenticationRepository.changePassword(
        oldPassword: params.oldPassword, newPassword: params.newPassword);
  }
}

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams(
      {required this.oldPassword, required this.newPassword});
  @override
  List<Object?> get props => [oldPassword, newPassword];
}

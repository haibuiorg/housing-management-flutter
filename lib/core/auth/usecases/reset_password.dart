import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class ResetPassword extends UseCase<bool, ResetPasswordParams> {
  final AuthenticationRepository authenticationRepository;

  ResetPassword({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(ResetPasswordParams params) async {
    return authenticationRepository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({required this.email});
  @override
  List<Object?> get props => [email];
}

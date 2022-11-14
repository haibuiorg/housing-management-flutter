import 'package:equatable/equatable.dart';

import '../../../base/failure.dart';
import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class LoginEmailPassword extends UseCase<bool, LoginEmailPasswordParams> {
  final AuthenticationRepository authenticationRepository;

  LoginEmailPassword({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(LoginEmailPasswordParams params) async {
    try {
      final isLoggedIn = await authenticationRepository.loginWithEmailPassword(
          email: params.email, password: params.password);
      return ResultSuccess(isLoggedIn);
    } catch (error) {
      return ResultFailure(ServerFailure());
    }
  }
}

class LoginEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const LoginEmailPasswordParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

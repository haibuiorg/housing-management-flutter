import 'package:equatable/equatable.dart';

import '../../base/failure.dart';
import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class LoginWithToken extends UseCase<bool, LoginWithTokenParams> {
  final AuthenticationRepository authenticationRepository;

  LoginWithToken({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(LoginWithTokenParams params) async {
    try {
      final isLoggedIn =
          await authenticationRepository.loginWithToken(token: params.token);
      return ResultSuccess(isLoggedIn);
    } catch (error) {
      return ResultFailure(ServerFailure());
    }
  }
}

class LoginWithTokenParams extends Equatable {
  final String token;

  const LoginWithTokenParams({required this.token});

  @override
  List<Object?> get props => [token];
}

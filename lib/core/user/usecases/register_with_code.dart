import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/user.dart';
import '../repos/user_repository.dart';

class RegisterWithCode extends UseCase<User, RegisterWithCodeParams> {
  final UserRepository userRepository;

  RegisterWithCode({required this.userRepository});

  @override
  Future<Result<User>> call(RegisterWithCodeParams params) {
    return userRepository.registerWithCode(
      email: params.email,
      password: params.password,
      code: params.code,
    );
  }
}

class RegisterWithCodeParams extends Equatable {
  final String password;
  final String email;
  final String code;

  const RegisterWithCodeParams({
    required this.code,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        code,
      ];
}

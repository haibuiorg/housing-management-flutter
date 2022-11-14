import 'package:equatable/equatable.dart';

import '../../result.dart';
import '../../usecase.dart';
import '../entities/user.dart';
import '../repos/user_repository.dart';

class CreateUser extends UseCase<User, CreateUserParams> {
  final UserRepository userRepository;

  CreateUser({required this.userRepository});

  @override
  Future<Result<User>> call(CreateUserParams params) {
    return userRepository.register(
      email: params.email,
      password: params.password,
      phone: params.phone,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class CreateUserParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  const CreateUserParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        phone,
      ];
}

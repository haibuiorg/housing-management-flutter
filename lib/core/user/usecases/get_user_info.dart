import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/user.dart';
import '../repos/user_repository.dart';

class GetUserInfo extends UseCase<User, NoParams> {
  final UserRepository userRepository;

  GetUserInfo({required this.userRepository});

  @override
  Future<Result<User>> call(NoParams params) {
    return userRepository.getUserInfo();
  }
}

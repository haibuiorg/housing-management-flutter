import '../../base/failure.dart';
import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class LogOut extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  LogOut({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(NoParams params) async {
    try {
      final logOutResult = await authenticationRepository.logOut();
      return ResultSuccess(logOutResult);
    } catch (error) {
      return ResultFailure(ServerFailure());
    }
  }
}

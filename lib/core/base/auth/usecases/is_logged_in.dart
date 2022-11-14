import '../../../base/failure.dart';
import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class IsLoggedIn extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  IsLoggedIn({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(NoParams params) async {
    try {
      final isUserLoggedIn = await authenticationRepository.isLoggedIn();
      return ResultSuccess(isUserLoggedIn);
    } catch (errors) {
      return ResultFailure(ServerFailure());
    }
  }
}

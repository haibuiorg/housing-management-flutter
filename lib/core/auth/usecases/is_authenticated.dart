import '../../base/failure.dart';
import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class IsAuthenticated extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  IsAuthenticated({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(NoParams params) async {
    try {
      final isAuthenticated = await authenticationRepository.isAuthenticated();
      return ResultSuccess(isAuthenticated);
    } catch (errors) {
      return ResultFailure(ServerFailure());
    }
  }
}

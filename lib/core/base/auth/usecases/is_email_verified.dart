import '../../../base/failure.dart';
import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class IsEmailVerified extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  IsEmailVerified({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(NoParams params) async {
    try {
      final isEmailVerified = await authenticationRepository.isEmailVerified();
      return ResultSuccess(isEmailVerified);
    } catch (errors) {
      return ResultFailure(ServerFailure());
    }
  }
}

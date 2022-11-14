import '../../../base/failure.dart';
import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../repos/authentication_repository.dart';

class CreateAnonymousUser extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  CreateAnonymousUser({required this.authenticationRepository});

  @override
  Future<Result<bool>> call(NoParams params) async {
    return ResultFailure(ServerFailure());
  }
}

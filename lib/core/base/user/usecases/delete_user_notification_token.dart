import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../repos/user_repository.dart';
import 'update_user_notification_token.dart';

class DeleteUserNotificationToken
    extends UseCase<bool, UpdateUserNotificationTokenParams> {
  final UserRepository userRepository;

  DeleteUserNotificationToken({required this.userRepository});

  @override
  Future<Result<bool>> call(UpdateUserNotificationTokenParams params) async {
    return userRepository.deleteNotificationToken(
        notificationToken: params.notificationToken);
  }
}

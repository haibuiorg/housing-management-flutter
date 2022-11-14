import 'package:equatable/equatable.dart';

import '../../../base/result.dart';
import '../../../base/usecase.dart';
import '../entities/user.dart';
import '../repos/user_repository.dart';

class UpdateUserNotificationToken
    extends UseCase<User, UpdateUserNotificationTokenParams> {
  final UserRepository userRepository;

  UpdateUserNotificationToken({required this.userRepository});

  @override
  Future<Result<User>> call(UpdateUserNotificationTokenParams params) async {
    return userRepository.updateUserNotificationToken(
        notificationToken: params.notificationToken);
  }
}

class UpdateUserNotificationTokenParams extends Equatable {
  final String notificationToken;

  const UpdateUserNotificationTokenParams({required this.notificationToken});

  @override
  List<Object?> get props => [notificationToken];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

class SubscriptionStatusCheck
    extends UseCase<Subscription, SubscriptionStatusCheckParams> {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionStatusCheck({required this.subscriptionRepository});
  @override
  Future<Result<Subscription>> call(SubscriptionStatusCheckParams params) {
    return subscriptionRepository.subscriptionStatusCheck(
      sessionId: params.sessionId,
    );
  }
}

class SubscriptionStatusCheckParams extends Equatable {
  final String sessionId;

  const SubscriptionStatusCheckParams({
    required this.sessionId,
  });

  @override
  List<Object?> get props => [sessionId];
}

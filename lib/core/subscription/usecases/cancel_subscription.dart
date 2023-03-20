import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import '../repos/subscription_repository.dart';

class CancelSubscription extends UseCase<bool, CancelSubscriptionParams> {
  final SubscriptionRepository repository;

  CancelSubscription({required this.repository});
  @override
  Future<Result<bool>> call(CancelSubscriptionParams params) {
    return repository.cancelSubscription(
        subscriptionId: params.subscriptionId, companyId: params.companyId);
  }
}

class CancelSubscriptionParams extends Equatable {
  final String subscriptionId;
  final String companyId;
  const CancelSubscriptionParams({
    required this.subscriptionId,
    required this.companyId,
  });

  @override
  List<Object?> get props => [
        subscriptionId,
        companyId,
      ];
}

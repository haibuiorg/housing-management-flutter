import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

class Checkout extends UseCase<String, CheckoutParams> {
  final SubscriptionRepository subscriptionRepository;

  Checkout({required this.subscriptionRepository});
  @override
  Future<Result<String>> call(CheckoutParams params) {
    return subscriptionRepository.checkout(
        subscriptionPlanId: params.subscriptionPlanId,
        companyId: params.companyId);
  }
}

class CheckoutParams extends Equatable {
  final String subscriptionPlanId;
  final String companyId;

  const CheckoutParams(
      {required this.subscriptionPlanId, required this.companyId});

  @override
  List<Object?> get props => [subscriptionPlanId, companyId];
}

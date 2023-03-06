import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

class GetAvailableSubscriptionPlans
    extends UseCase<List<SubscriptionPlan>, String> {
  final SubscriptionRepository subscriptionRepository;

  GetAvailableSubscriptionPlans({required this.subscriptionRepository});
  @override
  Future<Result<List<SubscriptionPlan>>> call(String params) {
    return subscriptionRepository.getAvailableSubscriptionPlan(
        countryCode: params);
  }
}

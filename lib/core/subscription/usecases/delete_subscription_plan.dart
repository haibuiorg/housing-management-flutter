import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/subscription_repository.dart';

class DeleteSubscriptionPlan extends UseCase<bool, String> {
  final SubscriptionRepository subscriptionRepository;

  DeleteSubscriptionPlan({required this.subscriptionRepository});

  @override
  Future<Result<bool>> call(String params) async {
    return subscriptionRepository.deleteSubscriptionPlan(
        subscriptionPlanId: params);
  }
}

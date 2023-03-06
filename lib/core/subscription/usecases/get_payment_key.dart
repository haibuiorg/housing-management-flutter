import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

class GetPaymentKey extends UseCase<String, NoParams> {
  final SubscriptionRepository subscriptionRepository;

  GetPaymentKey({required this.subscriptionRepository});
  @override
  Future<Result<String>> call(NoParams params) {
    return subscriptionRepository.getPaymentKey();
  }
}

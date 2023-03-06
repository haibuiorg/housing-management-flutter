import 'package:priorli/core/subscription/models/subscription_model.dart';
import 'package:priorli/core/subscription/models/subscription_plan_model.dart';

abstract class SubscriptionDataSource {
  Future<List<SubscriptionPlanModel>> getAvailableSubscriptionPlan(
      {required String countryCode});
  Future<SubscriptionPlanModel> addSubscriptionPlan({
    required String name,
    required double price,
    required String currency,
    required String countryCode,
    int? maxAccount,
    bool? translation,
    int? maxMessagingChannels,
    int? maxCompanyEvents,
    int? maxInvoiceNumber,
    double? additionalInvoiceCost,
    String? interval = 'month',
    int? intervalCount = 1,
  });
  Future<String> checkout(
      {required String subscriptionPlanId, required String companyId});
  Future<SubscriptionModel> subscriptionStatusCheck(
      {required String sessionId});
  Future<String> getPaymentKey();
}

import 'package:priorli/core/base/result.dart';

import '../entities/subscription.dart';
import '../entities/subscription_plan.dart';

abstract class SubscriptionRepository {
  Future<Result<List<SubscriptionPlan>>> getAvailableSubscriptionPlan(
      {required String countryCode});
  Future<Result<SubscriptionPlan>> addSubscriptionPlan({
    required String name,
    required double price,
    required String currency,
    required String countryCode,
    required bool hasApartmentDocument,
    required List<String> notificationTypes,
    int? maxAccount,
    bool? translation,
    int? maxMessagingChannels,
    int? maxAnnouncement,
    int? maxInvoiceNumber,
    required double additionalInvoiceCost,
    String? interval = 'month',
    int? intervalCount = 1,
  });
  Future<Result<Subscription>> subscriptionStatusCheck({
    required String sessionId,
  });
  Future<Result<String>> checkout(
      {required String subscriptionPlanId,
      required String companyId,
      required int quantity});
  Future<Result<String>> getPaymentKey();

  Future<Result<bool>> deleteSubscriptionPlan(
      {required String subscriptionPlanId});
  Future<Result<List<Subscription>>> getCompanySubscriptions(
      {required String companyId});
}

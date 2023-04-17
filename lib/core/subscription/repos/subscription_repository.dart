import 'package:priorli/core/base/result.dart';

import '../entities/payment_product_item.dart';
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
  Future<Result<bool>> cancelSubscription({
    required String subscriptionId,
    required String companyId,
  });
  Future<Result<bool>> deletePaymentProductItem(
      {required String paymentProductItemId});
  Future<Result<List<PaymentProductItem>>> getPaymentProductItems(
      {required String countryCode});
  Future<Result<PaymentProductItem>> addPaymentProductItem(
      {required String name,
      required String description,
      required double price,
      required String countryCode,
      required double taxPercentage});
  Future<Result<String>> purchasePaymentProduct({
    required String paymentProductItemId,
    required String companyId,
    required int quantity,
  });
}

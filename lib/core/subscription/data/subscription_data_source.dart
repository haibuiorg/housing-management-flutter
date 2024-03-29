import 'package:priorli/core/subscription/models/payment_product_item_model.dart';
import 'package:priorli/core/subscription/models/subscription_model.dart';
import 'package:priorli/core/subscription/models/subscription_plan_model.dart';

abstract class SubscriptionDataSource {
  Future<List<SubscriptionPlanModel>> getAvailableSubscriptionPlan(
      {required String countryCode});
  Future<String> checkout(
      {required String subscriptionPlanId,
      required String companyId,
      required int quantity});
  Future<String> purchasePaymentProduct(
      {required String paymentProductItemId,
      required String companyId,
      required int quantity});
  Future<SubscriptionModel> subscriptionStatusCheck(
      {required String sessionId});
  Future<String> getPaymentKey();
  // admin
  Future<SubscriptionPlanModel> addSubscriptionPlan({
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
  Future<bool> deleteSubscriptionPlan({required String subscriptionPlanId});
  Future<List<SubscriptionModel>> getCompanySubscriptions(
      {required String companyId});
  Future<bool> cancelSubscription(
      {required String subscriptionId, required String companyId});
  Future<PaymentProductItemModel> addPaymentProductItem({
    required String name,
    required String description,
    required double price,
    required String countryCode,
    required double taxPercentage,
  });
  Future<List<PaymentProductItemModel>> getPaymentProductItems(
      {required String countryCode});
  Future<bool> deletePaymentProductItem({required String paymentProductItemId});
}

import 'package:dio/dio.dart';
import 'package:priorli/core/subscription/data/subscription_data_source.dart';
import 'package:priorli/core/subscription/models/payment_product_item_model.dart';
import 'package:priorli/core/subscription/models/subscription_model.dart';
import 'package:priorli/core/subscription/models/subscription_plan_model.dart';

import '../../base/exceptions.dart';

class SubscriptionRemoteDataSource implements SubscriptionDataSource {
  final Dio client;

  SubscriptionRemoteDataSource({required this.client});
  @override
  Future<SubscriptionPlanModel> addSubscriptionPlan(
      {required String name,
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
      int? intervalCount = 1}) async {
    try {
      final data = {
        'name': name,
        'price': price,
        'currency': currency,
        'country_code': countryCode,
        'translation': translation,
        'max_messaging_channels': maxMessagingChannels,
        'max_announcement': maxAnnouncement,
        'has_apartment_document': hasApartmentDocument,
        'notification_types': notificationTypes,
        'max_invoice_number': maxInvoiceNumber,
        'additional_invoice_cost': additionalInvoiceCost,
        'interval': interval,
        'interval_count': intervalCount
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.post('/admin/subscription_plan', data: data);
      return SubscriptionPlanModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<String> checkout(
      {required String subscriptionPlanId,
      required String companyId,
      required int quantity}) async {
    try {
      final data = {
        'company_id': companyId,
        'subscription_plan_id': subscriptionPlanId,
        'quantity': quantity,
      };
      final result = await client.post('/checkout/subscription', data: data);
      return (result.data as Map).values.first;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<SubscriptionPlanModel>> getAvailableSubscriptionPlan(
      {required String countryCode}) async {
    try {
      final result = await client.get('/subscription_plans',
          queryParameters: {'country_code': countryCode});
      return (result.data as List<dynamic>)
          .map((e) => SubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<String> getPaymentKey() async {
    try {
      final result = await client.get('/payment_key');
      return (result.data as Map).values.first;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<SubscriptionModel> subscriptionStatusCheck(
      {required String sessionId}) async {
    try {
      final data = {
        'session_id': sessionId,
      };
      final result =
          await client.get('/subscription/status_check', queryParameters: data);
      return SubscriptionModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> deleteSubscriptionPlan(
      {required String subscriptionPlanId}) async {
    try {
      await client.delete('/admin/subscription_plan',
          queryParameters: {'subscription_plan_id': subscriptionPlanId});
      return true;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<SubscriptionModel>> getCompanySubscriptions(
      {required String companyId}) async {
    try {
      final result = await client
          .get('/subscriptions', queryParameters: {'company_id': companyId});
      return (result.data as List<dynamic>)
          .map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> cancelSubscription(
      {required String subscriptionId, required String companyId}) async {
    try {
      await client.delete('/subscription', queryParameters: {
        'subscription_id': subscriptionId,
        'company_id': companyId
      });
      return true;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PaymentProductItemModel> addPaymentProductItem(
      {required String name,
      required String description,
      required double price,
      required String countryCode}) async {
    final data = {
      'name': name,
      'description': description,
      'amount': price,
      'country_code': countryCode
    };
    try {
      final result = await client.post('/admin/payment_product', data: data);
      return PaymentProductItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> deletePaymentProductItem(
      {required String paymentProductItemId}) async {
    try {
      await client.delete('/admin/payment_product',
          queryParameters: {'id': paymentProductItemId});
      return true;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<PaymentProductItemModel>> getPaymentProductItems(
      {required String countryCode}) async {
    try {
      final result = await client.get('/payment_products',
          queryParameters: {'country_code': countryCode});
      return (result.data as List<dynamic>)
          .map((e) =>
              PaymentProductItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<String> purchasePaymentProduct(
      {required String paymentProductItemId,
      required String companyId,
      required int quantity}) async {
    try {
      final data = {
        'company_id': companyId,
        'payment_product_item_id': paymentProductItemId,
        'quantity': quantity,
      };
      final result = await client.post('/checkout/payment_product', data: data);
      return (result.data as Map).values.first;
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

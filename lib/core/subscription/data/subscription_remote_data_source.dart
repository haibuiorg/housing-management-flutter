import 'package:dio/dio.dart';
import 'package:priorli/core/subscription/data/subscription_data_source.dart';
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
      int? maxAccount,
      bool? translation,
      int? maxMessagingChannels,
      int? maxCompanyEvents,
      int? maxInvoiceNumber,
      double? additionalInvoiceCost,
      String? interval = 'month',
      int? intervalCount = 1}) async {
    try {
      final data = {
        'name': name,
        'price': price,
        'currency': currency,
        'country_code': countryCode,
        'max_account': maxAccount,
        'translation': translation,
        'max_messaging_channels': maxMessagingChannels,
        'max_company_events': maxCompanyEvents,
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
      {required String subscriptionPlanId, required String companyId}) async {
    try {
      final data = {
        'company_id': companyId,
        'subscription_plan_id': subscriptionPlanId,
      };
      final result = await client.post('/checkout', data: data);
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
}

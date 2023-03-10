import 'package:priorli/core/subscription/data/subscription_data_source.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDataSource subscriptionRemoteDataSource;

  SubscriptionRepositoryImpl({required this.subscriptionRemoteDataSource});
  @override
  Future<Result<SubscriptionPlan>> addSubscriptionPlan(
      {required String name,
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
      int? intervalCount = 1}) async {
    try {
      final subscriptionPlanModel =
          await subscriptionRemoteDataSource.addSubscriptionPlan(
              currency: currency,
              name: name,
              price: price,
              maxAccount: maxAccount,
              countryCode: countryCode,
              translation: translation,
              maxMessagingChannels: maxMessagingChannels,
              maxAnnouncement: maxAnnouncement,
              maxInvoiceNumber: maxInvoiceNumber,
              hasApartmentDocument: hasApartmentDocument,
              notificationTypes: notificationTypes,
              additionalInvoiceCost: additionalInvoiceCost,
              interval: interval,
              intervalCount: intervalCount);
      return ResultSuccess(
          SubscriptionPlan.modelToEntity(subscriptionPlanModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<String>> checkout(
      {required String subscriptionPlanId,
      required String companyId,
      required int quantity}) async {
    try {
      final url = await subscriptionRemoteDataSource.checkout(
          companyId: companyId,
          subscriptionPlanId: subscriptionPlanId,
          quantity: quantity);
      return ResultSuccess(url);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<SubscriptionPlan>>> getAvailableSubscriptionPlan(
      {required String countryCode}) async {
    try {
      final subscriptionPlanModelList = await subscriptionRemoteDataSource
          .getAvailableSubscriptionPlan(countryCode: countryCode);
      return ResultSuccess(subscriptionPlanModelList
          .map((e) => SubscriptionPlan.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<String>> getPaymentKey() async {
    try {
      final paymentKey = await subscriptionRemoteDataSource.getPaymentKey();
      return ResultSuccess(paymentKey);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Subscription>> subscriptionStatusCheck(
      {required String sessionId}) async {
    try {
      final subscriptionModel = await subscriptionRemoteDataSource
          .subscriptionStatusCheck(sessionId: sessionId);
      return ResultSuccess(Subscription.modelToEntity(subscriptionModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> deleteSubscriptionPlan(
      {required String subscriptionPlanId}) async {
    try {
      final subscriptionPlanModel = await subscriptionRemoteDataSource
          .deleteSubscriptionPlan(subscriptionPlanId: subscriptionPlanId);
      return ResultSuccess(subscriptionPlanModel);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Subscription>>> getCompanySubscriptions(
      {required String companyId}) async {
    try {
      final subscriptionModelList = await subscriptionRemoteDataSource
          .getCompanySubscriptions(companyId: companyId);
      return ResultSuccess(subscriptionModelList
          .map((e) => Subscription.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

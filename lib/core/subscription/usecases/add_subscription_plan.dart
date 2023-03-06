import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

class AddSubscriptionPlan
    extends UseCase<SubscriptionPlan, AddSubscriptionPlanParams> {
  final SubscriptionRepository subscriptionRepository;

  AddSubscriptionPlan({required this.subscriptionRepository});
  @override
  Future<Result<SubscriptionPlan>> call(AddSubscriptionPlanParams params) {
    return subscriptionRepository.addSubscriptionPlan(
        name: params.name,
        price: params.price,
        currency: params.currency,
        countryCode: params.countryCode,
        maxAccount: params.maxAccount,
        translation: params.translation,
        maxMessagingChannels: params.maxMessagingChannels,
        maxCompanyEvents: params.maxCompanyEvents,
        maxInvoiceNumber: params.maxInvoiceNumber,
        additionalInvoiceCost: params.additionalInvoiceCost,
        interval: params.interval,
        intervalCount: params.intervalCount);
  }
}

class AddSubscriptionPlanParams extends Equatable {
  final String name;
  final double price;
  final String currency;
  final String countryCode;
  final int? maxAccount;
  final bool? translation;
  final int? maxMessagingChannels;
  final int? maxCompanyEvents;
  final int? maxInvoiceNumber;
  final double? additionalInvoiceCost;
  final String? interval;
  final int? intervalCount;

  const AddSubscriptionPlanParams(
      {required this.name,
      required this.price,
      required this.currency,
      required this.countryCode,
      this.maxAccount,
      this.translation,
      this.maxMessagingChannels,
      this.maxCompanyEvents,
      this.maxInvoiceNumber,
      this.additionalInvoiceCost,
      this.interval,
      this.intervalCount});

  @override
  List<Object?> get props => [
        name,
        price,
        currency,
        countryCode,
        maxAccount,
        translation,
        maxMessagingChannels,
        maxCompanyEvents,
        maxInvoiceNumber,
        additionalInvoiceCost,
        interval,
        intervalCount
      ];
}

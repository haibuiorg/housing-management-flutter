import 'package:equatable/equatable.dart';
import 'package:priorli/core/subscription/models/subscription_plan_model.dart';

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String countryCode;
  final bool isActive;
  final String stripeProductId;
  final String stripePriceId;
  final int createdOn;
  final int maxAccount;
  final bool translation;
  final int maxMessagingChannels;
  final int maxCompanyEvents;
  final int maxInvoiceNumber;
  final double additionalInvoiceCost;
  final String interval;
  final int intervalCount;

  const SubscriptionPlan(
      {required this.id,
      required this.name,
      required this.price,
      required this.currency,
      required this.countryCode,
      required this.isActive,
      required this.stripeProductId,
      required this.stripePriceId,
      required this.createdOn,
      required this.maxAccount,
      required this.translation,
      required this.maxMessagingChannels,
      required this.maxCompanyEvents,
      required this.maxInvoiceNumber,
      required this.additionalInvoiceCost,
      required this.interval,
      required this.intervalCount});

  factory SubscriptionPlan.modelToEntity(SubscriptionPlanModel model) =>
      SubscriptionPlan(
          id: model.id,
          name: model.name,
          price: model.price,
          countryCode: model.country_code,
          currency: model.currency,
          isActive: model.is_active,
          stripeProductId: model.stripe_product_id,
          stripePriceId: model.stripe_price_id,
          createdOn: model.created_on,
          maxAccount: model.max_account,
          translation: model.translation,
          maxMessagingChannels: model.max_messaging_channels,
          maxCompanyEvents: model.max_company_events,
          maxInvoiceNumber: model.max_invoice_number,
          additionalInvoiceCost: model.additional_invoice_cost,
          interval: model.interval,
          intervalCount: model.interval_count);
  @override
  List<Object?> get props => [
        id,
        name,
        price,
        currency,
        countryCode,
        isActive,
        stripeProductId,
        stripePriceId,
        createdOn,
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

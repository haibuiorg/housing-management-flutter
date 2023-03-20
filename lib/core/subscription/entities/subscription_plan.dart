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
  final bool translation;
  final int maxMessagingChannels;
  final int maxAnnouncement;
  final int maxInvoiceNumber;
  final double additionalInvoiceCost;
  final String interval;
  final int intervalCount;
  final bool hasApartmentDocument;
  final List<String> notificationTypes;

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
      required this.translation,
      required this.maxMessagingChannels,
      required this.maxAnnouncement,
      required this.maxInvoiceNumber,
      required this.hasApartmentDocument,
      required this.notificationTypes,
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
          translation: model.translation,
          maxMessagingChannels: model.max_messaging_channels,
          maxAnnouncement: model.max_announcement ?? 1,
          maxInvoiceNumber: model.max_invoice_number,
          additionalInvoiceCost: model.additional_invoice_cost,
          interval: model.interval,
          notificationTypes: model.notification_types ?? ['push'],
          hasApartmentDocument: model.has_apartment_document ?? false,
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
        translation,
        maxMessagingChannels,
        maxAnnouncement,
        maxInvoiceNumber,
        additionalInvoiceCost,
        interval,
        intervalCount,
        hasApartmentDocument,
        notificationTypes,
      ];
}

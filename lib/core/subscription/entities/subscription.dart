import 'package:equatable/equatable.dart';
import 'package:priorli/core/subscription/models/subscription_model.dart';

class Subscription extends Equatable {
  final String subscriptionPlanId;
  final String id;
  final int createdOn;
  final int? endedOn;
  final String? checkoutSessionId;
  final String createdBy;
  final String companyId;
  final bool isActive;
  final String? paymentServiceSubscriptionId;
  final Map<String, dynamic>? detail;

  const Subscription(
      {required this.subscriptionPlanId,
      required this.id,
      this.detail,
      required this.paymentServiceSubscriptionId,
      required this.createdOn,
      this.endedOn,
      this.checkoutSessionId,
      required this.createdBy,
      required this.isActive,
      required this.companyId});

  factory Subscription.modelToEntity(SubscriptionModel model) => Subscription(
      subscriptionPlanId: model.subscription_plan_id,
      id: model.id,
      paymentServiceSubscriptionId: model.payment_service_subscription_id,
      isActive: model.is_active,
      createdOn: model.created_on,
      endedOn: model.ended_on,
      detail: model.detail,
      checkoutSessionId: model.checkout_session_id,
      createdBy: model.created_by,
      companyId: model.company_id);
  @override
  List<Object?> get props => [
        subscriptionPlanId,
        id,
        paymentServiceSubscriptionId,
        createdOn,
        endedOn,
        detail,
        isActive,
        checkoutSessionId,
        createdBy,
        companyId
      ];
}

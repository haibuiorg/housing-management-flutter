import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';

import '../../core/subscription/entities/payment_product_item.dart';

class CompanySubscriptionState extends Equatable {
  final HousingCompany? company;
  final List<Subscription>? companySubscriptionList;
  final List<SubscriptionPlan>? availableSubscriptionPlans;
  final List<PaymentProductItem>? paymentProducts;

  const CompanySubscriptionState(
      {this.company,
      this.paymentProducts,
      this.companySubscriptionList,
      this.availableSubscriptionPlans});

  CompanySubscriptionState copyWith(
          {HousingCompany? company,
          List<Subscription>? companySubscriptionList,
          List<SubscriptionPlan>? availableSubscriptionPlans,
          List<PaymentProductItem>? paymentProducts}) =>
      CompanySubscriptionState(
          company: company ?? this.company,
          paymentProducts: paymentProducts ?? this.paymentProducts,
          companySubscriptionList:
              companySubscriptionList ?? this.companySubscriptionList,
          availableSubscriptionPlans:
              availableSubscriptionPlans ?? this.availableSubscriptionPlans);

  @override
  List<Object?> get props => [
        company,
        companySubscriptionList,
        availableSubscriptionPlans,
        paymentProducts
      ];
}

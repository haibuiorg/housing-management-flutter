import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';

class CompanySubscriptionState extends Equatable {
  final HousingCompany? company;
  final List<Subscription>? companySubscriptionList;
  final List<SubscriptionPlan>? availableSubscriptionPlans;

  const CompanySubscriptionState(
      {this.company,
      this.companySubscriptionList,
      this.availableSubscriptionPlans});

  CompanySubscriptionState copyWith(
          {HousingCompany? company,
          List<Subscription>? companySubscriptionList,
          List<SubscriptionPlan>? availableSubscriptionPlans}) =>
      CompanySubscriptionState(
          company: company ?? this.company,
          companySubscriptionList:
              companySubscriptionList ?? this.companySubscriptionList,
          availableSubscriptionPlans:
              availableSubscriptionPlans ?? this.availableSubscriptionPlans);

  @override
  List<Object?> get props =>
      [company, companySubscriptionList, availableSubscriptionPlans];
}

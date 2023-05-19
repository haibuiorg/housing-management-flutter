import 'package:equatable/equatable.dart';
import 'package:priorli/core/contact_leads/entities/contact_lead.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';

class AdminState extends Equatable {
  final List<HousingCompany>? companyList;
  final List<ContactLead>? contactLeadList;
  final List<SubscriptionPlan>? subscriptionPlanList;
  final List<Country>? supportedCountries;
  final List<PaymentProductItem>? paymentProductItems;
  final List<String>? documentIndexes;
  final String? selectedCountryCode;
  const AdminState({
    this.paymentProductItems,
    this.companyList,
    this.contactLeadList,
    this.subscriptionPlanList,
    this.supportedCountries,
    this.selectedCountryCode,
    this.documentIndexes,
  });

  AdminState copyWith(
          {List<HousingCompany>? companyList,
          List<ContactLead>? contactLeadList,
          List<SubscriptionPlan>? subscriptionPlanList,
          List<Country>? supportedCountries,
          List<PaymentProductItem>? paymentProductItems,
          List<String>? documentIndexes,
          String? selectedCountryCode}) =>
      AdminState(
          documentIndexes: documentIndexes ?? this.documentIndexes,
          selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
          companyList: companyList ?? this.companyList,
          subscriptionPlanList:
              subscriptionPlanList ?? this.subscriptionPlanList,
          contactLeadList: contactLeadList ?? this.contactLeadList,
          supportedCountries: supportedCountries ?? this.supportedCountries,
          paymentProductItems: paymentProductItems ?? this.paymentProductItems);

  @override
  List<Object?> get props => [
        companyList,
        subscriptionPlanList,
        contactLeadList,
        supportedCountries,
        selectedCountryCode,
        paymentProductItems,
        documentIndexes
      ];
}

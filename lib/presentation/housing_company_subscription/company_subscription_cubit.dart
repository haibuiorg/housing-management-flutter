import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/check_out.dart';
import 'package:priorli/core/subscription/usecases/get_available_subscription_plans.dart';
import 'package:priorli/core/subscription/usecases/get_subscriptions.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_state.dart';

import '../../core/subscription/entities/subscription.dart';

class CompanySubscriptionCubit extends Cubit<CompanySubscriptionState> {
  final GetAvailableSubscriptionPlans _getAvailableSubscriptionPlans;
  final GetHousingCompany _getHousingCompany;
  final Checkout _checkout;
  final GetSubscriptions _getSubscriptions;
  CompanySubscriptionCubit(this._getAvailableSubscriptionPlans,
      this._getSubscriptions, this._getHousingCompany, this._checkout)
      : super(const CompanySubscriptionState());
  Future<void> init(String companyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(company: companyResult.data));
      getAvailableSubscriptionPlans();
      getCompanySubscriptions();
    }
  }

  Future<void> getCompanySubscriptions() async {
    final subscriptionResult = await _getSubscriptions(
        GetSubscriptionParams(companyId: state.company?.id ?? ''));
    if (subscriptionResult is ResultSuccess<List<Subscription>>) {
      emit(state.copyWith(companySubscriptionList: subscriptionResult.data));
    }
  }

  Future<void> getAvailableSubscriptionPlans() async {
    final availableSubscriptionPlanResult =
        await _getAvailableSubscriptionPlans(
            state.company?.countryCode ?? 'fi');
    if (availableSubscriptionPlanResult
        is ResultSuccess<List<SubscriptionPlan>>) {
      final List<SubscriptionPlan> availablePlans =
          List.from(availableSubscriptionPlanResult.data);
      availablePlans.sort((a, b) => a.price.compareTo(b.price));
      emit(state.copyWith(availableSubscriptionPlans: availablePlans));
    }
  }

  Future<String?> checkoutSubscriptionPlan(
      {String? subscriptionPlanId, required int quantity}) async {
    final sessionIdResult = await _checkout(CheckoutParams(
        quantity: quantity,
        subscriptionPlanId: subscriptionPlanId ??
            state.availableSubscriptionPlans?.first.id ??
            '',
        companyId: state.company?.id ?? ''));
    if (sessionIdResult is ResultSuccess<String>) {
      return sessionIdResult.data;
    }
    return null;
  }
}

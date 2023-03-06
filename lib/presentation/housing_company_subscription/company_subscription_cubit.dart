import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/check_out.dart';
import 'package:priorli/core/subscription/usecases/get_available_subscription_plans.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_state.dart';

class CompanySubscriptionCubit extends Cubit<CompanySubscriptionState> {
  final GetAvailableSubscriptionPlans _getAvailableSubscriptionPlans;
  final GetHousingCompany _getHousingCompany;
  final Checkout _checkout;
  CompanySubscriptionCubit(this._getAvailableSubscriptionPlans,
      this._getHousingCompany, this._checkout)
      : super(const CompanySubscriptionState());
  Future<void> init(String companyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(company: companyResult.data));
      final availableSubscriptionPlanResult =
          await _getAvailableSubscriptionPlans(companyResult.data.countryCode);
      if (availableSubscriptionPlanResult
          is ResultSuccess<List<SubscriptionPlan>>) {
        emit(state.copyWith(
            availableSubscriptionPlans: availableSubscriptionPlanResult.data));
      }
    }
  }

  Future<String?> checkoutSubscriptionPlan({String? subscriptionPlanId}) async {
    final sessionIdResult = await _checkout(CheckoutParams(
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

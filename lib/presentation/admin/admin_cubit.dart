import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/country/usecases/get_support_countries.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/add_subscription_plan.dart';
import 'package:priorli/presentation/admin/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AddSubscriptionPlan _addSubscriptionPlan;
  final GetSupportCountries _getSupportCountries;
  AdminCubit(this._addSubscriptionPlan, this._getSupportCountries)
      : super(const AdminState());

  Future<void> addSubscription({
    required String name,
    required double price,
    required String currency,
    required String countryCode,
    int? maxAccount,
    bool? translation,
    int? maxMessagingChannels,
    int? maxCompanyEvents,
    int? maxInvoiceNumber,
    double? additionalInvoiceCost,
    String? interval = 'month',
    int? intervalCount = 1,
  }) async {
    final addSubscriptionPlanResult = await _addSubscriptionPlan(
        AddSubscriptionPlanParams(
            name: name,
            price: price,
            currency: currency,
            countryCode: countryCode,
            maxAccount: maxAccount,
            translation: translation,
            maxMessagingChannels: maxMessagingChannels,
            maxCompanyEvents: maxCompanyEvents,
            maxInvoiceNumber: maxInvoiceNumber,
            additionalInvoiceCost: additionalInvoiceCost,
            interval: interval,
            intervalCount: intervalCount));
    if (addSubscriptionPlanResult is ResultSuccess<SubscriptionPlan>) {}
  }
}

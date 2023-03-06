import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/usecases/subscription_status_check.dart';
import 'package:priorli/presentation/payment_success/payment_success_state.dart';

class PaymentSuccessCubit extends Cubit<PaymentSuccessState> {
  final SubscriptionStatusCheck _subscriptionStatusCheck;
  PaymentSuccessCubit(
    this._subscriptionStatusCheck,
  ) : super(const PaymentSuccessState());
  Future<void> init(String sessionId) async {
    emit(state.copyWith(sessionId: sessionId));
    final subscriptionStatusResult = await _subscriptionStatusCheck(
        SubscriptionStatusCheckParams(sessionId: sessionId));
    if (subscriptionStatusResult is ResultSuccess<Subscription>) {
      emit(state.copyWith(
          sessionId: sessionId, subscription: subscriptionStatusResult.data));
    }
  }
}

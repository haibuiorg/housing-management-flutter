import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/subscription/usecases/get_payment_key.dart';
import 'package:priorli/presentation/checkout/check_out_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetPaymentKey _getPaymentKey;
  CheckoutCubit(
    this._getPaymentKey,
  ) : super(const CheckoutState());
  Future<void> init(String sessionId) async {
    final paymentKeyResult = await _getPaymentKey(NoParams());
    if (paymentKeyResult is ResultSuccess<String>) {
      emit(state.copyWith(
          sessionId: sessionId, paymentKey: paymentKeyResult.data));
      return;
    }
    emit(state.copyWith(sessionId: sessionId));
  }
}

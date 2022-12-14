import 'package:bloc/bloc.dart';
import 'package:priorli/core/auth/usecases/reset_password.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ResetPassword _resetPassword;
  ForgotPasswordCubit(this._resetPassword)
      : super(const ForgotPasswordState(resetPasswordEmailSent: false));

  Future<void> resetPassword({required String email}) async {
    final resetPasswordResult =
        await _resetPassword(ResetPasswordParams(email: email));
    emit(state.copyWith(
        resetPasswordEmailSent: resetPasswordResult is ResultSuccess));
  }

  initState() {
    emit(state.copyWith(resetPasswordEmailSent: false));
  }
}

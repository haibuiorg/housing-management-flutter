import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/code_register/code_register_state.dart';

class CodeRegisterCubit extends Cubit<CodeRegisterState> {
  CodeRegisterCubit() : super(const CodeRegisterState());

  init({String? email, String? code}) {
    emit(state.copyWith(email: email, code: code));
  }

  onTypingEmail(String email) {
    emit(state.copyWith(email: email));
  }

  onTypingCode(String code) {
    emit(state.copyWith(code: code));
  }

  onTypingPassword(String password) {
    emit(state.copyWith(password: password));
  }
}

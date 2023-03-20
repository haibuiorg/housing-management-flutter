import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/base/result.dart';
import '../../core/apartment/usecases/join_apartment.dart';
import 'join_apartment_state.dart';

class JoinApartmentCubit extends Cubit<JoinApartmentState> {
  final JoinApartment _joinApartment;

  JoinApartmentCubit(this._joinApartment) : super(const JoinApartmentState());

  init({String? code}) {
    emit(state.copyWith(code: code));
  }

  onTypingCode(String code) {
    emit(state.copyWith(
      code: code,
    ));
  }

  Future<void> joinWithCode() async {
    final joinApartmentResult = await _joinApartment(
        JoinApartmentParams(invitationCode: state.code ?? ''));
    if (joinApartmentResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(addedToApartment: joinApartmentResult.data));
    }
  }
}

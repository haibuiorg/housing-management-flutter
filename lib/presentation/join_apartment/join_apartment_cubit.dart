import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/base/result.dart';
import '../../core/apartment/usecases/join_apartment.dart';
import 'join_apartment_state.dart';

class JoinApartmentCubit extends Cubit<JoinApartmentState> {
  final JoinApartment _joinApartment;

  JoinApartmentCubit(this._joinApartment) : super(const JoinApartmentState());

  init({String? companyId, String? code}) {
    emit(state.copyWith(companyId: companyId, code: code));
  }

  onTypingCode(String code) {
    emit(state.copyWith(
        code: code.split('/')[1], companyId: code.split('/')[0]));
  }

  Future<void> joinWithCode() async {
    final joinApartmentResult = await _joinApartment(JoinApartmentParams(
        housingCompanyId: state.companyId ?? '',
        invitationCode: state.code ?? ''));
    if (joinApartmentResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(addedToApartment: joinApartmentResult.data));
    }
  }
}

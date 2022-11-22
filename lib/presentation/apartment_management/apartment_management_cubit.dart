import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/delete_apartment.dart';
import 'package:priorli/core/apartment/usecases/edit_apartment.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_state.dart';

import '../../core/apartment/usecases/get_apartment.dart';

class ApartmentManagementCubit extends Cubit<ApartmentManagementState> {
  final GetApartment _getApartment;
  final EditApartment _editApartment;
  final DeleteApartment _deleteApartment;
  ApartmentManagementCubit(
      this._getApartment, this._editApartment, this._deleteApartment)
      : super(const ApartmentManagementState());

  Future<ApartmentManagementState> init(
      String housingCompanyId, String apartmentId) async {
    final getApartmentResult = await _getApartment(GetApartmentSingleParams(
        apartmentId: apartmentId, housingCompanyId: housingCompanyId));
    if (getApartmentResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(
          apartment: getApartmentResult.data,
          pendingApartment: getApartmentResult.data));
    }
    return state;
  }

  updateAparmentBuildingName(String value) async {
    emit(state.copyWith(
        pendingApartment: state.pendingApartment?.copyWith(building: value)));
  }

  updateApartmentHousecode(String value) async {
    emit(state.copyWith(
        pendingApartment: state.pendingApartment?.copyWith(houseCode: value)));
    print(state.pendingApartment);
  }

  Future<bool> deleteThisApartment() async {
    final deleteApartmentResult = await _deleteApartment(
        GetApartmentSingleParams(
            housingCompanyId: state.apartment?.housingCompanyId ?? '',
            apartmentId: state.apartment?.id ?? ''));
    return deleteApartmentResult is ResultSuccess<Apartment> &&
        deleteApartmentResult.data.isDeleted;
  }

  Future<void> saveNewApartmentInfo() async {
    final saveNewInfo = await _editApartment(EditApartmentParams(
        houseCode: state.pendingApartment?.houseCode,
        building: state.pendingApartment?.building,
        housingCompanyId: state.apartment?.housingCompanyId ?? '',
        apartmentId: state.apartment?.id ?? ''));
    if (saveNewInfo is ResultSuccess<Apartment>) {
      print(saveNewInfo.data);
      emit(state.copyWith(
          apartment: saveNewInfo.data, pendingApartment: saveNewInfo.data));
    }
  }
}

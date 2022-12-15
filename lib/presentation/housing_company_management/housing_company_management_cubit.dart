import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/delete_housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/housing/usecases/update_housing_company_info.dart';

import 'housing_company_management_state.dart';

class HousingCompanyManagementCubit
    extends Cubit<HousingCompanyManagementState> {
  final GetHousingCompany _getHousingCompany;
  final UpdateHousingCompanyInfo _updateHousingCompanyInfo;
  final DeleteHousingCompany _deleteHousingCompany;
  HousingCompanyManagementCubit(
    this._updateHousingCompanyInfo,
    this._deleteHousingCompany,
    this._getHousingCompany,
  ) : super(const HousingCompanyManagementState());

  Future<HousingCompanyManagementState> init(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));

    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(
          housingCompany: companyResult.data,
          pendingUpdateHousingCompany: companyResult.data));
    }
    return state;
  }

  updateCompanyName(String newCompanyName) {
    final pending =
        state.pendingUpdateHousingCompany?.copyWith(name: newCompanyName);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  updateStreetAddress1(String newValue) {
    final pending =
        state.pendingUpdateHousingCompany?.copyWith(streetAddress1: newValue);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  updateStreetAddress2(String newValue) {
    final pending =
        state.pendingUpdateHousingCompany?.copyWith(streetAddress2: newValue);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  updatePostalCode(String newValue) {
    final pending =
        state.pendingUpdateHousingCompany?.copyWith(postalCode: newValue);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  updateCity(String newValue) {
    final pending = state.pendingUpdateHousingCompany?.copyWith(city: newValue);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  updateBusinessId(String newValue) {
    final pending =
        state.pendingUpdateHousingCompany?.copyWith(businessId: newValue);
    emit(state.copyWith(pendingUpdateHousingCompany: pending));
  }

  Future<void> deleteThisHousingCompany() async {
    final deleteResult = await _deleteHousingCompany(GetHousingCompanyParams(
        housingCompanyId: state.housingCompany?.id ?? ''));
    emit(state.copyWith(
        housingCompanyDeleted: deleteResult is ResultSuccess<HousingCompany>));
  }

  Future<void> saveNewCompanyDetail() async {
    final updateResult = await _updateHousingCompanyInfo(
        UpdateHousingCompanyInfoParams(
            housingCompanyId: state.housingCompany?.id ?? '',
            name: state.pendingUpdateHousingCompany?.name,
            streetAddress1: state.pendingUpdateHousingCompany?.streetAddress1,
            streetAddress2: state.pendingUpdateHousingCompany?.streetAddress2,
            postalCode: state.pendingUpdateHousingCompany?.postalCode,
            city: state.pendingUpdateHousingCompany?.city));
    if (updateResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(
          housingCompany: updateResult.data,
          pendingUpdateHousingCompany: updateResult.data));
    }
  }
}

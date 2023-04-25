import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/cancel_apartment_invitations.dart';
import 'package:priorli/core/apartment/usecases/delete_apartment.dart';
import 'package:priorli/core/apartment/usecases/edit_apartment.dart';
import 'package:priorli/core/apartment/usecases/edit_apartment_owner.dart';
import 'package:priorli/core/apartment/usecases/get_pending_apartment_invitation.dart';
import 'package:priorli/core/apartment/usecases/remove_tenant_from_apartment.dart';
import 'package:priorli/core/apartment/usecases/resend_apartment_invitation.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_state.dart';

import '../../core/apartment/usecases/get_apartment.dart';
import '../../core/apartment/usecases/get_apartment_tenants.dart';

class ApartmentManagementCubit extends Cubit<ApartmentManagementState> {
  final GetApartment _getApartment;
  final EditApartment _editApartment;
  final DeleteApartment _deleteApartment;
  final GetApartmentTenants _getApartmentTenants;
  final GetPendingApartmentInvitations _getPendingApartmentInvitations;
  final CancelApartmentInvitation _cancelApartmentInvitation;
  final ResendApartmentInvitation _resendApartmentInvitation;
  final RemoveTenantFromApartment _removeTenantFromApartment;
  final EditApartmentOwner _editApartmentOwner;

  ApartmentManagementCubit(
      this._cancelApartmentInvitation,
      this._getPendingApartmentInvitations,
      this._getApartment,
      this._editApartment,
      this._editApartmentOwner,
      this._deleteApartment,
      this._resendApartmentInvitation,
      this._removeTenantFromApartment,
      this._getApartmentTenants)
      : super(const ApartmentManagementState());

  Future<ApartmentManagementState> init(
      String housingCompanyId, String apartmentId) async {
    final getApartmentResult = await _getApartment(GetApartmentSingleParams(
        apartmentId: apartmentId, housingCompanyId: housingCompanyId));
    if (getApartmentResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(
          apartment: getApartmentResult.data,
          pendingApartment: getApartmentResult.data));
      getApartmentTenant();
    }
    return state;
  }

  Future<void> getApartmentTenant() async {
    final getApartmentTenantResult = await _getApartmentTenants(
        GetApartmentSingleParams(
            apartmentId: state.apartment?.id ?? '',
            housingCompanyId: state.apartment?.housingCompanyId ?? ''));
    if (getApartmentTenantResult is ResultSuccess<List<User>>) {
      emit(state.copyWith(
          tenants: getApartmentTenantResult.data
              .where((element) =>
                  state.apartment?.tenants?.contains(element.userId) == true)
              .toList(),
          owners: getApartmentTenantResult.data
              .where((element) =>
                  state.apartment?.owners?.contains(element.userId) == true)
              .toList()));
    }
  }

  updateAparmentBuildingName(String value) async {
    emit(state.copyWith(
        pendingApartment: state.pendingApartment?.copyWith(building: value)));
  }

  updateApartmentHousecode(String value) async {
    emit(state.copyWith(
        pendingApartment: state.pendingApartment?.copyWith(houseCode: value)));
  }

  Future<void> deleteThisApartment() async {
    final deleteApartmentResult = await _deleteApartment(
        GetApartmentSingleParams(
            housingCompanyId: state.apartment?.housingCompanyId ?? '',
            apartmentId: state.apartment?.id ?? ''));
    emit(state.copyWith(
        deleted: deleteApartmentResult is ResultSuccess<Apartment> &&
            deleteApartmentResult.data.isDeleted));
  }

  Future<void> saveNewApartmentInfo() async {
    final saveNewInfo = await _editApartment(EditApartmentParams(
        houseCode: state.pendingApartment?.houseCode,
        building: state.pendingApartment?.building,
        housingCompanyId: state.apartment?.housingCompanyId ?? '',
        apartmentId: state.apartment?.id ?? ''));
    if (saveNewInfo is ResultSuccess<Apartment>) {
      emit(state.copyWith(
        apartment: saveNewInfo.data,
        pendingApartment: saveNewInfo.data,
      ));
    }
  }
}

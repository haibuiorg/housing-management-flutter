import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/entities/apartment_invitation.dart';
import 'package:priorli/core/apartment/usecases/get_apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_tenants.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/presentation/apartment_management_tenants/tenant_management_state.dart';

import '../../core/apartment/usecases/cancel_apartment_invitations.dart';
import '../../core/apartment/usecases/edit_apartment_owner.dart';
import '../../core/apartment/usecases/get_pending_apartment_invitation.dart';
import '../../core/apartment/usecases/remove_tenant_from_apartment.dart';
import '../../core/apartment/usecases/resend_apartment_invitation.dart';
import '../../core/user/entities/user.dart';

class TenantManagmentCubit extends Cubit<TenantManagementState> {
  final GetPendingApartmentInvitations _getPendingApartmentInvitations;
  final CancelApartmentInvitation _cancelApartmentInvitation;
  final ResendApartmentInvitation _resendApartmentInvitation;
  final RemoveTenantFromApartment _removeTenantFromApartment;
  final EditApartmentOwner _editApartmentOwner;
  final GetApartmentTenants _getApartmentTenants;
  final GetApartment _getApartment;

  TenantManagmentCubit(
      this._getPendingApartmentInvitations,
      this._cancelApartmentInvitation,
      this._resendApartmentInvitation,
      this._removeTenantFromApartment,
      this._editApartmentOwner,
      this._getApartment,
      this._getApartmentTenants)
      : super(const TenantManagementState());

  Future<void> init(String? companyId, String? apartmentId) async {
    emit(state.copyWith(apartmentId: apartmentId, companyId: companyId));
    getApartmentInfo();
    getApartmentTenants();
    getPendingInvitations();
  }

  Future<void> getPendingInvitations() async {
    final getPendingApartmentInvitationResult =
        await _getPendingApartmentInvitations(GetApartmentSingleParams(
            housingCompanyId: state.companyId ?? '',
            apartmentId: state.apartmentId ?? ''));
    if (getPendingApartmentInvitationResult
        is ResultSuccess<List<ApartmentInvitation>>) {
      emit(state.copyWith(
          pendingInvitations: getPendingApartmentInvitationResult.data));
    }
  }

  Future<void> getApartmentTenants() async {
    final getAparmentTenantResult = await _getApartmentTenants(
        GetApartmentSingleParams(
            housingCompanyId: state.companyId ?? '',
            apartmentId: state.apartmentId ?? ''));
    if (getAparmentTenantResult is ResultSuccess<List<User>>) {
      emit(state.copyWith(tenants: getAparmentTenantResult.data));
    }
  }

  Future<void> getApartmentInfo() async {
    final getApartmentInfo = await _getApartment(GetApartmentSingleParams(
        housingCompanyId: state.companyId ?? '',
        apartmentId: state.apartmentId ?? ''));
    if (getApartmentInfo is ResultSuccess<Apartment>) {
      emit(state.copyWith(owners: getApartmentInfo.data.owners));
    }
  }

  Future<void> changeRole(String userId) async {
    if (state.owners?.contains(userId) == true) {
      final editApartmentOwnerResult = await _editApartmentOwner(
          ApartmentOwnerParams(
              housingCompanyId: state.companyId ?? '',
              apartmentId: state.apartmentId ?? '',
              ownerIds: state.owners
                      ?.where((element) => element != userId)
                      .toList() ??
                  []));
      if (editApartmentOwnerResult is ResultSuccess<Apartment>) {
        emit(state.copyWith(owners: editApartmentOwnerResult.data.owners));
      }
      return;
    }
    final editApartmentOwnerResult =
        await _editApartmentOwner(ApartmentOwnerParams(
            housingCompanyId: state.companyId ?? '',
            apartmentId: state.apartmentId ?? '',
            ownerIds: {
              ...?state.owners,
              ...[userId]
            }.toList()));
    if (editApartmentOwnerResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(owners: editApartmentOwnerResult.data.owners));
    }
  }

  Future<void> resendApartmentInvitation(String invitationId) async {
    final resendApartmentInvitationResult = await _resendApartmentInvitation(
        ResendApartmentInvitationParams(
            housingCompanyId: state.companyId ?? '',
            invitationId: invitationId));
    if (resendApartmentInvitationResult is ResultSuccess<ApartmentInvitation>) {
      final List<ApartmentInvitation> currentInvitations =
          List.from(state.pendingInvitations ?? []);
      currentInvitations.removeWhere((element) => element.id == invitationId);
      currentInvitations.add(resendApartmentInvitationResult.data);
      emit(state.copyWith(pendingInvitations: currentInvitations));
    }
  }

  Future<void> cancelApartmentInvitation(String invitationId) async {
    final cancelApartmentInvitationResult = await _cancelApartmentInvitation(
        CancelApartmentInvitationParams(
            housingCompanyId: state.companyId ?? '',
            invitationIds: [invitationId]));
    if (cancelApartmentInvitationResult
        is ResultSuccess<List<ApartmentInvitation>>) {
      emit(state.copyWith(
          pendingInvitations: cancelApartmentInvitationResult.data));
    }
  }

  Future<void> removeTenant(String tenantId) async {
    final removeApartmentTenantResult = await _removeTenantFromApartment(
        RemoveAparmentUserParams(
            companyId: state.companyId ?? '',
            apartmentId: state.apartmentId ?? '',
            userId: tenantId));
    if (removeApartmentTenantResult is ResultSuccess<bool>) {
      if (removeApartmentTenantResult.data) {
        final List<User> currentTenants = List.from(state.tenants ?? []);
        currentTenants.removeWhere((element) => element.userId == tenantId);
        emit(state.copyWith(tenants: currentTenants));
      }
    }
  }
}

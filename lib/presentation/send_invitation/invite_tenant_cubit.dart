import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment_invitation.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_state.dart';

import '../../core/apartment/entities/apartment.dart';
import '../../core/apartment/usecases/get_apartments.dart';
import '../../core/apartment/usecases/send_invitation_to_apartment.dart';
import '../../core/base/result.dart';
import '../../core/housing/entities/housing_company.dart';
import '../../core/housing/usecases/get_housing_company.dart';

class InviteTenantCubit extends Cubit<InviteTenantState> {
  final GetApartments _getApartments;
  final GetHousingCompany _getHousingCompany;
  final SendInvitationToApartment _sendInvitationToApartment;
  InviteTenantCubit(this._getApartments, this._getHousingCompany,
      this._sendInvitationToApartment)
      : super(const InviteTenantState());

  Future<void> init(String housingCompanyId) async {
    _getHousingCompanyData(housingCompanyId);
    _getAparmentData(housingCompanyId);
  }

  Future<void> _getHousingCompanyData(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(
          housingCompany: companyResult.data,
          housingCompanyId: housingCompanyId));
    }
  }

  Future<void> _getAparmentData(String housingCompanyId) async {
    final apartResult = await _getApartments(
        GetApartmentParams(housingCompanyId: housingCompanyId));
    if (apartResult is ResultSuccess<List<Apartment>>) {
      emit(state.copyWith(
          apartmentList: apartResult.data, housingCompanyId: housingCompanyId));
    }
  }

  setSelectedApartmentId(String id) {
    emit(state.copyWith(selectedApartment: id));
  }

  updateNumberOfInvitation(int numberOfInvitations) {
    emit(state.copyWith(numberOfInvitations: numberOfInvitations));
  }

  updateEmails(String value) {
    value = value.replaceAll(" ", "").replaceAll(";", "/").replaceAll(",", "/");

    final emails =
        value.split("/").where((element) => element.isValidEmail).toList();
    emit(state.copyWith(emails: emails));
  }

  Future<void> sendInvitation() async {
    final sendInvitationResult = await _sendInvitationToApartment(
        SendInvitationToApartmentParams(
            housingCompanyId: state.housingCompanyId ?? '',
            apartmentId: state.selectedApartment ?? '',
            numberOfTenants: state.numberOfInvitations,
            emails: state.emails));

    if (sendInvitationResult is ResultSuccess<ApartmentInvitation>) {
      emit(state.copyWith(popNow: true));
    }
  }
}

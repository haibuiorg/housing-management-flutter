import 'package:equatable/equatable.dart';

import '../../core/apartment/entities/apartment.dart';
import '../../core/housing/entities/housing_company.dart';

class InviteTenantState extends Equatable {
  final HousingCompany? housingCompany;
  final List<Apartment>? apartmentList;
  final String? selectedApartment;
  final List<String>? emails;
  final String? housingCompanyId;
  final String? errorText;
  final int numberOfInvitations;
  final bool? popNow;

  const InviteTenantState(
      {this.housingCompany,
      this.apartmentList,
      this.selectedApartment,
      this.emails,
      this.errorText,
      this.housingCompanyId,
      this.popNow,
      this.numberOfInvitations = 1});

  InviteTenantState copyWith(
          {HousingCompany? housingCompany,
          List<Apartment>? apartmentList,
          String? selectedApartment,
          List<String>? emails,
          String? errorText,
          int? numberOfInvitations,
          bool? popNow,
          String? housingCompanyId}) =>
      InviteTenantState(
          popNow: popNow ?? this.popNow,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          errorText: errorText ?? this.errorText,
          housingCompany: housingCompany ?? this.housingCompany,
          apartmentList: apartmentList ?? this.apartmentList,
          selectedApartment: selectedApartment ?? this.selectedApartment,
          numberOfInvitations: numberOfInvitations ?? this.numberOfInvitations,
          emails: emails ?? this.emails);

  @override
  List<Object?> get props => [
        housingCompany,
        apartmentList,
        selectedApartment,
        emails,
        numberOfInvitations,
        errorText,
        housingCompanyId,
        popNow
      ];
}

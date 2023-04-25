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
  final bool? popNow;
  final bool? isLoading;
  final bool? setAsApartmentOwner;

  const InviteTenantState({
    this.housingCompany,
    this.apartmentList,
    this.selectedApartment,
    this.emails,
    this.errorText,
    this.housingCompanyId,
    this.popNow,
    this.isLoading,
    this.setAsApartmentOwner,
  });

  InviteTenantState copyWith(
          {HousingCompany? housingCompany,
          List<Apartment>? apartmentList,
          String? selectedApartment,
          List<String>? emails,
          String? errorText,
          bool? popNow,
          bool? setAsApartmentOwner,
          bool? isLoading,
          String? housingCompanyId}) =>
      InviteTenantState(
          popNow: popNow ?? this.popNow,
          isLoading: isLoading ?? this.isLoading,
          setAsApartmentOwner: setAsApartmentOwner ?? this.setAsApartmentOwner,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          errorText: errorText ?? this.errorText,
          housingCompany: housingCompany ?? this.housingCompany,
          apartmentList: apartmentList ?? this.apartmentList,
          selectedApartment: selectedApartment ?? this.selectedApartment,
          emails: emails ?? this.emails);

  @override
  List<Object?> get props => [
        housingCompany,
        apartmentList,
        isLoading,
        setAsApartmentOwner,
        selectedApartment,
        emails,
        errorText,
        housingCompanyId,
        popNow
      ];
}

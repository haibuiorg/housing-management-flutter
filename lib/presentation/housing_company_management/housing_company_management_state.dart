import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HousingCompanyManagementState extends Equatable {
  final HousingCompany? housingCompany;
  final HousingCompany? pendingUpdateHousingCompany;
  final bool? housingCompanyDeleted;
  const HousingCompanyManagementState(
      {this.housingCompany,
      this.pendingUpdateHousingCompany,
      this.housingCompanyDeleted});

  HousingCompanyManagementState copyWith(
          {HousingCompany? housingCompany,
          HousingCompany? pendingUpdateHousingCompany,
          bool? housingCompanyDeleted}) =>
      HousingCompanyManagementState(
          housingCompanyDeleted:
              housingCompanyDeleted ?? this.housingCompanyDeleted,
          housingCompany: housingCompany ?? this.housingCompany,
          pendingUpdateHousingCompany:
              pendingUpdateHousingCompany ?? this.pendingUpdateHousingCompany);

  @override
  List<Object?> get props =>
      [housingCompany, pendingUpdateHousingCompany, housingCompanyDeleted];
}

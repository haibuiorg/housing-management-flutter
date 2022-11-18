import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HousingCompanyManagementState extends Equatable {
  final HousingCompany? housingCompany;
  final HousingCompany? pendingUpdateHousingCompany;
  const HousingCompanyManagementState(
      {this.housingCompany, this.pendingUpdateHousingCompany});

  HousingCompanyManagementState copyWith(
          {HousingCompany? housingCompany,
          HousingCompany? pendingUpdateHousingCompany}) =>
      HousingCompanyManagementState(
          housingCompany: housingCompany ?? this.housingCompany,
          pendingUpdateHousingCompany:
              pendingUpdateHousingCompany ?? this.pendingUpdateHousingCompany);

  @override
  List<Object?> get props => [housingCompany, pendingUpdateHousingCompany];
}

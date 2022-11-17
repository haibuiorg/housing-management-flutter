import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class MainState extends Equatable {
  final List<HousingCompany>? housingCompanies;
  final String? selectedHousingCompanyId;

  const MainState({this.housingCompanies, this.selectedHousingCompanyId});

  @override
  List<Object?> get props => [housingCompanies];

  factory MainState.init() =>
      const MainState(housingCompanies: [], selectedHousingCompanyId: null);

  MainState copyWith(
          {List<HousingCompany>? housingCompanies,
          String? selectedHousingCompanyId}) =>
      MainState(
          housingCompanies: housingCompanies ?? this.housingCompanies,
          selectedHousingCompanyId:
              selectedHousingCompanyId ?? this.selectedHousingCompanyId);
}

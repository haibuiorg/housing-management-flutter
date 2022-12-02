import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HomeState extends Equatable {
  final List<HousingCompany>? housingCompanies;
  final String? selectedHousingCompanyId;

  const HomeState({this.housingCompanies, this.selectedHousingCompanyId});

  @override
  List<Object?> get props => [housingCompanies, selectedHousingCompanyId];

  factory HomeState.init() =>
      const HomeState(housingCompanies: [], selectedHousingCompanyId: null);

  HomeState copyWith(
          {List<HousingCompany>? housingCompanies,
          String? selectedHousingCompanyId}) =>
      HomeState(
          housingCompanies: housingCompanies ?? this.housingCompanies,
          selectedHousingCompanyId:
              selectedHousingCompanyId ?? this.selectedHousingCompanyId);
}

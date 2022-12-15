import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HousingCompanyUiScreenState extends Equatable {
  final HousingCompany? company;

  const HousingCompanyUiScreenState({
    this.company,
  });

  HousingCompanyUiScreenState copyWith({HousingCompany? company}) =>
      HousingCompanyUiScreenState(
        company: company ?? this.company,
      );

  @override
  List<Object?> get props => [company];
}

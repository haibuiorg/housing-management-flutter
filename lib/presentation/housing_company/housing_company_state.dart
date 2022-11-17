import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HousingCompanyState extends Equatable {
  final HousingCompany? housingCompany;
  final List<Apartment>? apartmentList;
  const HousingCompanyState({
    this.housingCompany,
    this.apartmentList,
  });

  HousingCompanyState copyWith(
          {HousingCompany? housingCompany, List<Apartment>? apartmentList}) =>
      HousingCompanyState(
          housingCompany: housingCompany ?? this.housingCompany,
          apartmentList: apartmentList ?? this.apartmentList);

  @override
  List<Object?> get props => [housingCompany, apartmentList];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

import '../../core/water_usage/entities/water_consumption.dart';

class HousingCompanyState extends Equatable {
  final HousingCompany? housingCompany;
  final List<Apartment>? apartmentList;
  final List<WaterConsumption>? yearlyWaterConsumption;
  const HousingCompanyState(
      {this.housingCompany, this.apartmentList, this.yearlyWaterConsumption});

  HousingCompanyState copyWith(
          {HousingCompany? housingCompany,
          List<Apartment>? apartmentList,
          List<WaterConsumption>? yearlyWaterConsumption}) =>
      HousingCompanyState(
          yearlyWaterConsumption:
              yearlyWaterConsumption ?? this.yearlyWaterConsumption,
          housingCompany: housingCompany ?? this.housingCompany,
          apartmentList: apartmentList ?? this.apartmentList);

  @override
  List<Object?> get props =>
      [housingCompany, apartmentList, yearlyWaterConsumption];
}

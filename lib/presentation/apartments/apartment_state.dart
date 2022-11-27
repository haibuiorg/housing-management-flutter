import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';

class ApartmentState extends Equatable {
  final Apartment? apartment;
  final WaterConsumption? latestWaterConsumption;
  final List<WaterBill>? yearlyWaterBills;
  final HousingCompany? housingCompany;
  final bool? newConsumptionAdded;

  const ApartmentState(
      {this.housingCompany,
      this.apartment,
      this.yearlyWaterBills,
      this.latestWaterConsumption,
      this.newConsumptionAdded});

  ApartmentState copyWith(
          {Apartment? apartment,
          HousingCompany? housingCompany,
          List<WaterBill>? yearlyWaterBills,
          bool? newConsumptionAdded,
          WaterConsumption? latestWaterConsumption}) =>
      ApartmentState(
          newConsumptionAdded: newConsumptionAdded ?? this.newConsumptionAdded,
          apartment: apartment ?? this.apartment,
          housingCompany: housingCompany ?? this.housingCompany,
          latestWaterConsumption:
              latestWaterConsumption ?? this.latestWaterConsumption,
          yearlyWaterBills: yearlyWaterBills ?? this.yearlyWaterBills);

  @override
  List<Object?> get props => [
        apartment,
        yearlyWaterBills,
        latestWaterConsumption,
        housingCompany,
        newConsumptionAdded
      ];
}

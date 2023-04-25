import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';

class ApartmentState extends Equatable {
  final Apartment? apartment;
  final WaterConsumption? latestWaterConsumption;
  final List<WaterBill>? yearlyWaterBills;
  final HousingCompany? housingCompany;
  final Conversation? newFaultReport;
  final List<Conversation>? faultReportList;
  final bool ownerView;
  final bool isLoading;

  const ApartmentState(
      {this.housingCompany,
      this.apartment,
      this.isLoading = false,
      this.yearlyWaterBills,
      this.faultReportList,
      this.latestWaterConsumption,
      this.ownerView = false,
      this.newFaultReport});

  ApartmentState copyWith(
          {Apartment? apartment,
          HousingCompany? housingCompany,
          List<WaterBill>? yearlyWaterBills,
          Conversation? newFaultReport,
          List<Conversation>? faultReportList,
          bool? ownerView,
          bool? isLoading,
          WaterConsumption? latestWaterConsumption}) =>
      ApartmentState(
          newFaultReport: newFaultReport ?? this.newFaultReport,
          apartment: apartment ?? this.apartment,
          housingCompany: housingCompany ?? this.housingCompany,
          ownerView: ownerView ?? this.ownerView,
          faultReportList: faultReportList ?? this.faultReportList,
          latestWaterConsumption:
              latestWaterConsumption ?? this.latestWaterConsumption,
          isLoading: isLoading ?? this.isLoading,
          yearlyWaterBills: yearlyWaterBills ?? this.yearlyWaterBills);

  @override
  List<Object?> get props => [
        apartment,
        yearlyWaterBills,
        latestWaterConsumption,
        housingCompany,
        newFaultReport,
        ownerView,
        isLoading,
        faultReportList
      ];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';

class WaterConsumptionManagementState extends Equatable {
  final String? housingCompanyId;
  final HousingCompany? housingCompany;
  final String? errorText;
  final WaterPrice? activeWaterPrice;
  final List<WaterPrice>? waterPriceHistory;
  final WaterConsumption? latestWaterConsumption;
  const WaterConsumptionManagementState(
      {this.errorText,
      this.housingCompanyId,
      this.housingCompany,
      this.activeWaterPrice,
      this.latestWaterConsumption,
      this.waterPriceHistory});

  WaterConsumptionManagementState copyWith(
          {String? housingCompanyId,
          String? errorText,
          HousingCompany? housingCompany,
          List<WaterPrice>? waterPriceHistory,
          WaterConsumption? latestWaterConsumption,
          WaterPrice? activeWaterPrice}) =>
      WaterConsumptionManagementState(
          latestWaterConsumption:
              latestWaterConsumption ?? this.latestWaterConsumption,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          errorText: errorText ?? this.errorText,
          housingCompany: housingCompany ?? this.housingCompany,
          activeWaterPrice: activeWaterPrice ?? this.activeWaterPrice,
          waterPriceHistory: waterPriceHistory ?? this.waterPriceHistory);

  @override
  List<Object?> get props => [
        housingCompanyId,
        errorText,
        housingCompany,
        activeWaterPrice,
        waterPriceHistory
      ];
}

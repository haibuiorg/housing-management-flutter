import 'package:equatable/equatable.dart';
import 'package:priorli/core/water_usage/models/water_bill_model.dart';

class WaterBill extends Equatable {
  final String id;
  final int period;
  final int year;
  final String url;
  final int createdOn;
  final double consumption;
  final String currencyCode;
  final double invoiceValue;

  const WaterBill({
    required this.id,
    required this.period,
    required this.year,
    required this.url,
    required this.consumption,
    required this.createdOn,
    required this.currencyCode,
    required this.invoiceValue,
  });

  factory WaterBill.modelToEntity(WaterBillModel model) => WaterBill(
      year: model.year ?? DateTime.now().year,
      period: model.period ?? 1,
      id: model.id ?? '',
      url: model.url ?? '',
      consumption: model.consumption ?? 0,
      invoiceValue: model.invoiceValue ?? 0,
      currencyCode: model.currencyCode ?? '',
      createdOn: model.createdOn ?? DateTime.now().millisecondsSinceEpoch);

  @override
  List<Object?> get props => [
        id,
        year,
        period,
        url,
        createdOn,
        currencyCode,
        invoiceValue,
        consumption
      ];
}

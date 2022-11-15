import 'package:equatable/equatable.dart';
import 'package:priorli/core/water_usage/models/water_bill_model.dart';

class WaterBill extends Equatable {
  final String id;
  final int period;
  final int year;
  final String url;
  final int createdOn;

  const WaterBill(
      {required this.id,
      required this.period,
      required this.year,
      required this.url,
      required this.createdOn});

  factory WaterBill.modelToEntity(WaterBillModel model) => WaterBill(
      year: model.year,
      period: model.period,
      id: model.id,
      url: model.url,
      createdOn: model.createdOn);

  @override
  List<Object?> get props => [id, year, period, url, createdOn];
}

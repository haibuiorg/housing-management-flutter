import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';

class ApartmentWaterInvoiceState extends Equatable {
  final Apartment? apartment;
  final List<WaterBill>? waterBillList;
  final String? waterBillLink;

  const ApartmentWaterInvoiceState(
      {this.apartment, this.waterBillList, this.waterBillLink});

  ApartmentWaterInvoiceState copyWith(
          {Apartment? apartment,
          List<WaterBill>? waterBillList,
          String? waterBillLink}) =>
      ApartmentWaterInvoiceState(
          waterBillLink: waterBillLink ?? this.waterBillLink,
          apartment: apartment ?? this.apartment,
          waterBillList: waterBillList ?? this.waterBillList);

  @override
  List<Object?> get props => [apartment, waterBillList, waterBillLink];
}

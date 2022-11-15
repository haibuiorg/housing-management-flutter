import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/water_usage/models/water_bill_model.dart';
import 'package:priorli/core/water_usage/models/water_price_model.dart';

class WaterPrice extends Equatable {
  final double basicFee;
  final String id;
  final bool isActive;
  final double pricePerCube;
  final int updatedOn;

  const WaterPrice(
      {required this.basicFee,
      required this.id,
      required this.isActive,
      required this.pricePerCube,
      required this.updatedOn});
  factory WaterPrice.modelToEntity(WaterPriceModel model) => WaterPrice(
      basicFee: model.basicFee,
      id: model.id,
      isActive: model.isActive,
      pricePerCube: model.pricePerCube,
      updatedOn: model.updatedOn);

  @override
  List<Object?> get props => [basicFee, id, isActive, pricePerCube, updatedOn];
}

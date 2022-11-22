import 'package:equatable/equatable.dart';

import '../models/consumption_value_model.dart';

class ConsumptionValue extends Equatable {
  final String apartmentId;
  final String buiding;
  final double consumption;
  final int updatedOn;

  const ConsumptionValue(
      {required this.apartmentId,
      required this.buiding,
      required this.consumption,
      required this.updatedOn});

  factory ConsumptionValue.modelToEntity(ConsumptionValueModel model) =>
      ConsumptionValue(
          apartmentId: model.apartmentId ?? '',
          buiding: model.buiding ?? '',
          consumption: model.consumption ?? 0,
          updatedOn: model.updatedOn ?? 0);

  @override
  List<Object?> get props => [apartmentId, buiding, consumption, updatedOn];
}

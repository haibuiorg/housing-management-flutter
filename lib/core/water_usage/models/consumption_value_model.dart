import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumption_value_model.g.dart';

@JsonSerializable()
class ConsumptionValueModel extends Equatable {
  @JsonKey(name: 'apartment_id')
  final String apartmentId;
  final String buiding;
  final double consumption;
  @JsonKey(name: 'updated_on')
  final int updatedOn;

  const ConsumptionValueModel(
      {required this.apartmentId,
      required this.buiding,
      required this.consumption,
      required this.updatedOn});

  factory ConsumptionValueModel.fromJson(Map<String, dynamic> json) =>
      _$ConsumptionValueModelFromJson(json);

  @override
  List<Object?> get props => [apartmentId, buiding, consumption, updatedOn];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'water_price_model.g.dart';

@JsonSerializable()
class WaterPriceModel extends Equatable {
  @JsonKey(name: 'basic_fee')
  final double basicFee;
  final String id;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'price_per_cube')
  final double pricePerCube;
  @JsonKey(name: 'updated_on')
  final int updatedOn;

  const WaterPriceModel(
      {required this.basicFee,
      required this.id,
      required this.isActive,
      required this.pricePerCube,
      required this.updatedOn});
  factory WaterPriceModel.fromJson(Map<String, dynamic> json) =>
      _$WaterPriceModelFromJson(json);
  @override
  List<Object?> get props => [basicFee, id, isActive, pricePerCube, updatedOn];
}

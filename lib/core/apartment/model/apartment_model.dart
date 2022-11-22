import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apartment_model.g.dart';

@JsonSerializable()
class ApartmentModel extends Equatable {
  @JsonKey(name: 'housing_company_id')
  final String housingCompanyId;
  final String id;
  final String building;
  @JsonKey(name: 'house_code')
  final String? houseCode;
  final List<String> tenants;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;

  const ApartmentModel(
      {required this.housingCompanyId,
      required this.id,
      required this.building,
      this.isDeleted,
      this.houseCode,
      required this.tenants});

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);

  @override
  List<Object?> get props =>
      [housingCompanyId, id, building, houseCode, tenants, isDeleted];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';

class Apartment extends Equatable {
  final String housingCompanyId;
  final String id;
  final String building;
  final String? houseCode;
  final List<String> tenants;

  const Apartment(
      {required this.housingCompanyId,
      required this.id,
      required this.building,
      this.houseCode,
      required this.tenants});

  factory Apartment.modelToEntity(ApartmentModel apartmentModel) => Apartment(
      housingCompanyId: apartmentModel.housingCompanyId,
      id: apartmentModel.id,
      building: apartmentModel.building,
      houseCode: apartmentModel.houseCode,
      tenants: apartmentModel.tenants);

  @override
  List<Object?> get props =>
      [housingCompanyId, id, building, houseCode, tenants];
}

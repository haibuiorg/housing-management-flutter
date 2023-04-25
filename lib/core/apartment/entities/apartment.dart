import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';

class Apartment extends Equatable {
  final String housingCompanyId;
  final String id;
  final String building;
  final String? houseCode;
  final bool isDeleted;
  final List<String>? tenants;
  final List<String>? owners;

  const Apartment(
      {required this.housingCompanyId,
      required this.id,
      required this.building,
      this.houseCode,
      required this.isDeleted,
      this.tenants,
      this.owners});

  factory Apartment.modelToEntity(ApartmentModel apartmentModel) => Apartment(
      housingCompanyId: apartmentModel.housingCompanyId,
      id: apartmentModel.id,
      building: apartmentModel.building,
      isDeleted: apartmentModel.isDeleted ?? false,
      houseCode: apartmentModel.houseCode,
      owners: apartmentModel.owners,
      tenants: apartmentModel.tenants);

  Apartment copyWith(
          {String? housingCompanyId,
          String? id,
          String? building,
          String? houseCode,
          List<String>? owners,
          bool? isDeleted,
          List<String>? tenants}) =>
      Apartment(
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          id: id ?? this.id,
          owners: owners ?? this.owners,
          houseCode: houseCode ?? this.houseCode,
          building: building ?? this.building,
          isDeleted: isDeleted ?? this.isDeleted,
          tenants: tenants ?? this.tenants);

  @override
  List<Object?> get props =>
      [housingCompanyId, id, building, houseCode, owners, tenants, isDeleted];
}

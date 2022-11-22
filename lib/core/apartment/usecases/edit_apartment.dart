import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class EditApartment extends UseCase<Apartment, EditApartmentParams> {
  final ApartmentRepository apartmentRepository;

  EditApartment({required this.apartmentRepository});
  @override
  Future<Result<Apartment>> call(EditApartmentParams params) {
    return apartmentRepository.editApartmentInfo(
        housingCompanyId: params.housingCompanyId,
        building: params.building,
        apartmentId: params.apartmentId,
        houseCode: params.houseCode);
  }
}

class EditApartmentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final String? building;
  final String? houseCode;

  const EditApartmentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      this.building,
      this.houseCode});

  @override
  List<Object?> get props =>
      [housingCompanyId, building, houseCode, apartmentId];
}

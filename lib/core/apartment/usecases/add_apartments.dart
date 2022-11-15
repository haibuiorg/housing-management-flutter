import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class AddApartments extends UseCase<List<Apartment>, AddApartmentParams> {
  final ApartmentRepository apartmentRepository;

  AddApartments({required this.apartmentRepository});
  @override
  Future<Result<List<Apartment>>> call(AddApartmentParams params) {
    return apartmentRepository.addApartments(
        housingCompanyId: params.housingCompanyId,
        building: params.building,
        houseCodes: params.houseCodes);
  }
}

class AddApartmentParams extends Equatable {
  final String housingCompanyId;
  final String building;
  final List<String>? houseCodes;

  const AddApartmentParams(
      {required this.housingCompanyId,
      required this.building,
      this.houseCodes});

  @override
  List<Object?> get props => [housingCompanyId, building, houseCodes];
}

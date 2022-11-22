import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class GetApartment extends UseCase<Apartment, GetApartmentSingleParams> {
  final ApartmentRepository apartmentRepository;

  GetApartment({required this.apartmentRepository});
  @override
  Future<Result<Apartment>> call(GetApartmentSingleParams params) {
    return apartmentRepository.getUserApartment(
        apartmentId: params.apartmentId,
        housingCompanyId: params.housingCompanyId);
  }
}

class GetApartmentSingleParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  const GetApartmentSingleParams(
      {required this.housingCompanyId, required this.apartmentId});

  @override
  List<Object?> get props => [housingCompanyId, apartmentId];
}

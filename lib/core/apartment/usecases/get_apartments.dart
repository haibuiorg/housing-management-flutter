import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class GetApartments extends UseCase<List<Apartment>, GetApartmentParams> {
  final ApartmentRepository apartmentRepository;

  GetApartments({required this.apartmentRepository});
  @override
  Future<Result<List<Apartment>>> call(GetApartmentParams params) {
    return apartmentRepository.getUserApartments(
        housingCompanyId: params.housingCompanyId);
  }
}

class GetApartmentParams extends Equatable {
  final String housingCompanyId;

  const GetApartmentParams({
    required this.housingCompanyId,
  });

  @override
  List<Object?> get props => [housingCompanyId];
}

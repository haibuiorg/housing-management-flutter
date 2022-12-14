import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class JoinApartment extends UseCase<Apartment, JoinApartmentParams> {
  final ApartmentRepository apartmentRepository;

  JoinApartment({required this.apartmentRepository});
  @override
  Future<Result<Apartment>> call(JoinApartmentParams params) {
    return apartmentRepository.joinApartment(
        invitationCode: params.invitationCode,
        housingCompanyId: params.housingCompanyId);
  }
}

class JoinApartmentParams extends Equatable {
  final String housingCompanyId;
  final String invitationCode;
  const JoinApartmentParams(
      {required this.housingCompanyId, required this.invitationCode});

  @override
  List<Object?> get props => [housingCompanyId, invitationCode];
}

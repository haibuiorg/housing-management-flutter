import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/repos/apartment_repository.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

class EditApartmentOwner extends UseCase<Apartment, ApartmentOwnerParams> {
  final ApartmentRepository apartmentRepository;

  EditApartmentOwner(this.apartmentRepository);

  @override
  Future<Result<Apartment>> call(ApartmentOwnerParams params) {
    return apartmentRepository.editApartmentInfo(
        housingCompanyId: params.housingCompanyId,
        ownersIds: params.ownerIds,
        apartmentId: params.apartmentId);
  }
}

class ApartmentOwnerParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final List<String> ownerIds;

  const ApartmentOwnerParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.ownerIds});

  @override
  List<Object?> get props => [housingCompanyId, apartmentId, ownerIds];
}

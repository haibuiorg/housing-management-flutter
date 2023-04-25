import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/repos/apartment_repository.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

class RemoveTenantFromApartment
    extends UseCase<bool, RemoveAparmentUserParams> {
  final ApartmentRepository repository;

  RemoveTenantFromApartment(this.repository);
  @override
  Future<Result<bool>> call(RemoveAparmentUserParams params) {
    return repository.removeTenantFromApartment(
        housingCompanyId: params.companyId,
        apartmentId: params.apartmentId,
        removedUserId: params.userId);
  }
}

class RemoveAparmentUserParams extends Equatable {
  final String companyId;
  final String userId;
  final String apartmentId;

  const RemoveAparmentUserParams(
      {required this.companyId,
      required this.userId,
      required this.apartmentId});

  @override
  List<Object?> get props => [companyId, userId, apartmentId];
}

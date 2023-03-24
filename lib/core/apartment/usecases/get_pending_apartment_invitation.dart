import 'package:priorli/core/apartment/repos/apartment_repository.dart';
import 'package:priorli/core/base/result.dart';

import '../../base/usecase.dart';
import '../entities/apartment_invitation.dart';
import 'get_apartment.dart';

class GetPendingApartmentInvitations
    extends UseCase<List<ApartmentInvitation>, GetApartmentSingleParams> {
  final ApartmentRepository repository;

  GetPendingApartmentInvitations(this.repository);

  @override
  Future<Result<List<ApartmentInvitation>>> call(
      GetApartmentSingleParams params) async {
    return await repository.getApartmentInvitations(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        status: 'pending');
  }
}

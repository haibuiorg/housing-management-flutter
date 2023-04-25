import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment_invitation.dart';
import '../repos/apartment_repository.dart';

class CancelApartmentInvitation extends UseCase<List<ApartmentInvitation>,
    CancelApartmentInvitationParams> {
  final ApartmentRepository repository;

  CancelApartmentInvitation(this.repository);

  @override
  Future<Result<List<ApartmentInvitation>>> call(
      CancelApartmentInvitationParams params) async {
    return repository.cancelApartmentInvitation(
        housingCompanyId: params.housingCompanyId,
        invitationIds: params.invitationIds);
  }
}

class CancelApartmentInvitationParams extends Equatable {
  final String housingCompanyId;
  final List<String> invitationIds;

  const CancelApartmentInvitationParams(
      {required this.housingCompanyId, required this.invitationIds});

  @override
  List<Object?> get props => [housingCompanyId, invitationIds];
}

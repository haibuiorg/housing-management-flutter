import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment_invitation.dart';
import '../repos/apartment_repository.dart';

class ResendApartmentInvitation
    extends UseCase<ApartmentInvitation, ResendApartmentInvitationParams> {
  final ApartmentRepository repository;

  ResendApartmentInvitation(this.repository);

  @override
  Future<Result<ApartmentInvitation>> call(
      ResendApartmentInvitationParams params) async {
    return await repository.resentApartmentInvitation(
        housingCompanyId: params.housingCompanyId,
        invitationId: params.invitationId);
  }
}

class ResendApartmentInvitationParams extends Equatable {
  final String housingCompanyId;
  final String invitationId;

  const ResendApartmentInvitationParams(
      {required this.housingCompanyId, required this.invitationId});

  @override
  List<Object?> get props => [housingCompanyId, invitationId];
}

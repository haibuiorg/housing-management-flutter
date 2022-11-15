import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment_invitation.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/apartment_repository.dart';

class SendInvitationToApartment
    extends UseCase<ApartmentInvitation, SendInvitationToApartmentParams> {
  final ApartmentRepository apartmentRepository;

  SendInvitationToApartment({required this.apartmentRepository});
  @override
  Future<Result<ApartmentInvitation>> call(
      SendInvitationToApartmentParams params) {
    return apartmentRepository.sendInvitationToApartment(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        numberOfTenants: params.numberOfTenants,
        emails: params.emails);
  }
}

class SendInvitationToApartmentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final List<String>? emails;
  final int numberOfTenants;

  const SendInvitationToApartmentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.numberOfTenants,
      this.emails});

  @override
  List<Object?> get props =>
      [housingCompanyId, apartmentId, numberOfTenants, emails];
}

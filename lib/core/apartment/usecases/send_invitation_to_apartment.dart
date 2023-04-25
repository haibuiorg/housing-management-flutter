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
        setAsApartmentOwner: params.setAsApartmentOwner,
        emails: params.emails);
  }
}

class SendInvitationToApartmentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final bool setAsApartmentOwner;
  final List<String>? emails;

  const SendInvitationToApartmentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      this.emails,
      required this.setAsApartmentOwner});

  @override
  List<Object?> get props =>
      [housingCompanyId, apartmentId, emails, setAsApartmentOwner];
}

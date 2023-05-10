import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';

class ApartmentInvitation extends Equatable {
  final String invitationCode;
  final String id;
  final int isValid;
  final int validUntil;
  final String apartmentId;
  final String housingCompanyId;
  final List<String>? claimedBy;
  final int emailSent;
  final String? email;
  final int inviteRetryLimit;

  const ApartmentInvitation(
      {required this.invitationCode,
      required this.id,
      required this.isValid,
      required this.validUntil,
      required this.apartmentId,
      required this.housingCompanyId,
      required this.emailSent,
      required this.inviteRetryLimit,
      this.email,
      this.claimedBy});

  factory ApartmentInvitation.modelToEntity(
          ApartmentInvitationModel apartmentInvitationModel) =>
      ApartmentInvitation(
          email: apartmentInvitationModel.email,
          invitationCode: apartmentInvitationModel.invitationCode,
          id: apartmentInvitationModel.id,
          emailSent: apartmentInvitationModel.emailSent,
          inviteRetryLimit: apartmentInvitationModel.inviteRetryLimit,
          isValid: apartmentInvitationModel.isValid,
          validUntil: apartmentInvitationModel.validUntil,
          apartmentId: apartmentInvitationModel.apartmentId,
          housingCompanyId: apartmentInvitationModel.housingCompanyId);

  @override
  List<Object?> get props => [
        invitationCode,
        id,
        isValid,
        validUntil,
        apartmentId,
        housingCompanyId,
        claimedBy,
        emailSent,
        email,
        inviteRetryLimit
      ];
}

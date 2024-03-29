import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apartment_invitation_model.g.dart';

@JsonSerializable()
class ApartmentInvitationModel extends Equatable {
  @JsonKey(name: 'invitation_code')
  final String invitationCode;
  final String id;
  @JsonKey(name: 'is_valid')
  final int isValid;
  @JsonKey(name: 'valid_until')
  final int validUntil;
  @JsonKey(name: 'apartment_id')
  final String apartmentId;
  @JsonKey(name: 'housing_company_id')
  final String housingCompanyId;
  @JsonKey(name: 'claimed_by')
  final List<String>? claimedBy;
  @JsonKey(name: 'email_sent')
  final int emailSent;
  @JsonKey(name: 'invite_retry_limit')
  final int inviteRetryLimit;
  final String? email;

  const ApartmentInvitationModel(
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

  factory ApartmentInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentInvitationModelFromJson(json);

  @override
  List<Object?> get props => [
        invitationCode,
        id,
        isValid,
        validUntil,
        apartmentId,
        email,
        housingCompanyId,
        claimedBy,
        emailSent,
        inviteRetryLimit
      ];
}

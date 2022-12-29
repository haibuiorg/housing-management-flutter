import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  final String phone;
  final String email;
  final List<dynamic>? roles;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'avatar_url')
  final dynamic avatarUrl;
  @JsonKey(name: 'email_verified')
  final bool? emailVerified;

  const UserModel(this.userId, this.phone, this.email, this.roles,
      this.firstName, this.lastName, this.avatarUrl, this.emailVerified);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props =>
      [userId, phone, email, roles, firstName, lastName, avatarUrl];
}

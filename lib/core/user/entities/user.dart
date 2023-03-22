import 'package:equatable/equatable.dart';

import '../models/user_model.dart';

class User extends Equatable {
  final String userId;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final bool? emailVerified;
  final List<String> roles;
  final List<String>? apartments;
  final String countryCode;

  const User(
      {required this.userId,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.roles,
      required this.countryCode,
      this.apartments,
      this.avatarUrl,
      this.emailVerified});

  factory User.modelToEntity(UserModel userModel) {
    return User(
        userId: userModel.userId,
        email: userModel.email,
        phone: userModel.phone,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        roles: userModel.roles?.map((e) => e.toString()).toList() ?? [],
        avatarUrl: userModel.avatarUrl,
        countryCode: userModel.countryCode ?? 'fi',
        emailVerified: userModel.emailVerified);
  }

  User copyWith({
    String? userId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    bool? emailVerified,
    List<String>? roles,
    List<String>? apartments,
  }) =>
      User(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        roles: roles ?? this.roles,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        emailVerified: emailVerified ?? this.emailVerified,
        apartments: apartments ?? this.apartments,
        countryCode: countryCode,
      );

  @override
  List<Object?> get props => [
        userId,
        email,
        phone,
        firstName,
        lastName,
        roles,
        roles.length,
        avatarUrl,
        emailVerified,
        apartments,
        countryCode
      ];
}

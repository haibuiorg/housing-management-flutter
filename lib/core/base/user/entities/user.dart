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

  const User(this.userId, this.email, this.phone, this.firstName, this.lastName,
      this.roles, this.avatarUrl, this.emailVerified);

  factory User.modelToEntity(UserModel userModel) {
    return User(
        userModel.userId,
        userModel.email,
        userModel.phone,
        userModel.firstName,
        userModel.lastName,
        userModel.roles,
        userModel.avatarUrl,
        userModel.emailVerified);
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        phone,
        firstName,
        lastName,
        roles,
        avatarUrl,
        emailVerified
      ];
}

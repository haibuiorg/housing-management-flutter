import 'package:equatable/equatable.dart';

class CodeRegisterState extends Equatable {
  final String? email;
  final String? code;
  final String? password;

  const CodeRegisterState({this.email, this.code, this.password});

  CodeRegisterState copyWith(
          {String? email, String? password, String? code, String? companyId}) =>
      CodeRegisterState(
          email: email ?? this.email,
          code: code ?? this.code,
          password: password ?? this.password);

  @override
  List<Object?> get props => [
        email,
        code,
        password,
      ];
}

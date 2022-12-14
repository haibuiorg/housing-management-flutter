import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool resetPasswordEmailSent;

  const ForgotPasswordState({required this.resetPasswordEmailSent});

  ForgotPasswordState copyWith({bool? resetPasswordEmailSent}) =>
      ForgotPasswordState(
          resetPasswordEmailSent:
              resetPasswordEmailSent ?? this.resetPasswordEmailSent);

  @override
  List<Object?> get props => [resetPasswordEmailSent];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import '../repos/contact_lead_repo.dart';

class SubmitContactForm extends UseCase<bool, SubmitContactFormParams> {
  final ContactLeadRepo contactLeadRepo;

  SubmitContactForm({required this.contactLeadRepo});
  @override
  Future<Result<bool>> call(SubmitContactFormParams params) {
    return contactLeadRepo.submitContactForm(
      name: params.name,
      email: params.email,
      phone: params.phone,
      message: params.message,
      bookDemo: params.bookDemo,
    );
  }
}

class SubmitContactFormParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String message;
  final bool bookDemo;

  const SubmitContactFormParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.bookDemo,
  });

  @override
  List<Object?> get props => [name, email, phone, message, bookDemo];
}

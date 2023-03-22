import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/contact_leads/usecases/submit_contact_form.dart';

import 'contact_us_public_state.dart';

class ContactUsPublicCubit extends Cubit<ContactUsPublicState> {
  final SubmitContactForm _submitContactForm;
  ContactUsPublicCubit(this._submitContactForm)
      : super(const ContactUsPublicState());
  Future<bool> submitForm(
      {required String name,
      required String email,
      required String phone,
      required String message,
      required bool bookDemo}) async {
    final submitFormResult = await _submitContactForm(SubmitContactFormParams(
      name: name,
      email: email,
      phone: phone,
      message: message,
      bookDemo: bookDemo,
    ));
    return submitFormResult is ResultSuccess<bool> && submitFormResult.data;
  }
}

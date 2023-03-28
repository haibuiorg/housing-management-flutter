import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_cubit.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';
import '../shared/custom_form_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const forgotPasswordPath = '/forgotPassword';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final ForgotPasswordCubit _cubit;

  @override
  initState() {
    _emailController = TextEditingController();
    _cubit = serviceLocator<ForgotPasswordCubit>();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _emailController.dispose();
  }

  _submitResetPassword() async {
    await _cubit.resetPassword(email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
        if (state.resetPasswordEmailSent) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child:
                      Text(AppLocalizations.of(context).reset_password_success),
                );
              });
          _cubit.initState();
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).reset_password),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
                top: MediaQuery.of(context).padding.top),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(
                    height: 200,
                    width: 200,
                    child: AppLottieAnimation(
                      loadingResource: 'forgot_password',
                    )),
                const Spacer(),
                Text(
                  AppLocalizations.of(context).forgot_password,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    AppLocalizations.of(context).reset_password_instruction,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                CustomFormField(
                  hintText: AppLocalizations.of(context).email,
                  textEditingController: _emailController,
                  autoValidate: true,
                  keyboardType: TextInputType.emailAddress,
                  icon: const Icon(
                    Icons.mail_outline_rounded,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    return (!val!.isValidEmail)
                        ? AppLocalizations.of(context).email_address_error
                        : null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48)),
                      onPressed: _emailController.text.isValidEmail
                          ? _submitResetPassword
                          : null,
                      child: Text(AppLocalizations.of(context).reset_password)),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

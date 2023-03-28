import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/code_register/code_register_cubit.dart';
import 'package:priorli/presentation/code_register/code_register_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const codeRegisterPath = '/code_register';

class CodeRegisterScreen extends StatefulWidget {
  const CodeRegisterScreen({super.key, this.email, this.code});
  final String? email;
  final String? code;

  @override
  State<CodeRegisterScreen> createState() => _CodeRegisterScreenState();
}

class _CodeRegisterScreenState extends State<CodeRegisterScreen> {
  late final CodeRegisterCubit _cubit;
  bool _isObscured = true;
  @override
  void initState() {
    _cubit = serviceLocator<CodeRegisterCubit>()
      ..init(code: widget.code, email: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CodeRegisterCubit>(
        create: (_) => _cubit,
        child: BlocBuilder<CodeRegisterCubit, CodeRegisterState>(
            builder: (context, state) => Scaffold(
                  appBar: AppBar(
                    title:
                        Text(AppLocalizations.of(context).register_with_code),
                  ),
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFormField(
                            hintText: AppLocalizations.of(context).email,
                            autofocus: true,
                            initialValue: '${state.email}',
                            autoValidate: true,
                            keyboardType: TextInputType.emailAddress,
                            icon: const Icon(
                              Icons.mail_outline_rounded,
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              return (!val!.isValidEmail)
                                  ? AppLocalizations.of(context)
                                      .email_address_error
                                  : null;
                            },
                            onChanged: (email) => _cubit.onTypingEmail(email)),
                        CustomFormField(
                          hintText: AppLocalizations.of(context).code_title,
                          icon: const Icon(
                            Icons.abc,
                          ),
                          helperText: AppLocalizations.of(context)
                              .invitation_code_from_manager,
                          initialValue: state.code ?? '',
                          onChanged: (code) => _cubit.onTypingCode(code),
                        ),
                        CustomFormField(
                          autoValidate: true,
                          hintText:
                              AppLocalizations.of(context).create_a_password,
                          onChanged: (password) {
                            setState(() {});
                            _cubit.onTypingPassword(password);
                          },
                          icon: const Icon(
                            Icons.lock_outline_rounded,
                          ),
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  })),
                          validator: (val) {
                            return !val!.isValidPassword
                                ? AppLocalizations.of(context).password_error
                                : null;
                          },
                        ),
                        OutlinedButton(
                            onPressed: state.email?.isValidEmail == true &&
                                    state.password?.isValidPassword == true
                                ? () => BlocProvider.of<AuthCubit>(context)
                                    .registerWithCode(
                                        email: state.email,
                                        code: state.code,
                                        password: state.password)
                                    .then((success) => {
                                          if (!success)
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(AppLocalizations
                                                            .of(context)
                                                        .invalid_code_or_email)))
                                        })
                                : null,
                            child: Text(AppLocalizations.of(context).register))
                      ]),
                )));
  }
}

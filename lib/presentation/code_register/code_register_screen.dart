import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/code_register/code_register_cubit.dart';
import 'package:priorli/presentation/code_register/code_register_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';

const codeRegisterPath = '/code_register';

class CodeRegisterScreen extends StatefulWidget {
  const CodeRegisterScreen({super.key, this.companyId, this.code});
  final String? companyId;
  final String? code;

  @override
  State<CodeRegisterScreen> createState() => _CodeRegisterScreenState();
}

class _CodeRegisterScreenState extends State<CodeRegisterScreen> {
  late final CodeRegisterCubit _cubit;
  bool _isObscured = true;
  @override
  void initState() {
    _cubit = serviceLocator<CodeRegisterCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CodeRegisterCubit>(
        create: (_) =>
            _cubit..init(code: widget.code, companyId: widget.companyId),
        child: BlocBuilder<CodeRegisterCubit, CodeRegisterState>(
            builder: (context, state) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Register with code'),
                  ),
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFormField(
                            hintText: 'Email',
                            autofocus: true,
                            autoValidate: true,
                            keyboardType: TextInputType.emailAddress,
                            icon: const Icon(
                              Icons.mail_outline_rounded,
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              return (!val!.isValidEmail)
                                  ? 'Enter valid email'
                                  : null;
                            },
                            onChanged: (email) => _cubit.onTypingEmail(email)),
                        CustomFormField(
                          hintText: 'Code',
                          icon: const Icon(
                            Icons.abc,
                          ),
                          helperText: 'Invitation code from company',
                          initialValue: '${state.companyId}/${state.code}',
                          onChanged: (code) => _cubit.onTypingCode(code),
                        ),
                        CustomFormField(
                          autoValidate: true,
                          hintText: 'Create a password',
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
                                ? 'Enter valid password'
                                : null;
                          },
                        ),
                        OutlinedButton(
                            onPressed: state.email?.isValidEmail == true &&
                                    state.password?.isValidPassword == true
                                ? () => BlocProvider.of<AuthCubit>(context)
                                    .registerWithCode()
                                : null,
                            child: const Text('Register'))
                      ]),
                )));
  }
}

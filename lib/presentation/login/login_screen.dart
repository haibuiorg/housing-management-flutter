import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/code_register/code_register_screen.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_screen.dart';
import 'package:priorli/presentation/register/register_screen.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../shared/custom_form_field.dart';

const loginPath = '/login';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;
  _login(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).logIn(
        email: _emailController.text, password: _passwordController.text);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveRowColumn(
        columnMainAxisAlignment: MainAxisAlignment.center,
        layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'logo.png',
                    height: 120,
                    fit: BoxFit.scaleDown,
                  ),
                  CustomFormField(
                    textEditingController: _emailController,
                    hintText: 'Email',
                    autoValidate: true,
                    keyboardType: TextInputType.emailAddress,
                    icon: const Icon(
                      Icons.mail_outline_rounded,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      return (!val!.isValidEmail) ? 'Enter valid email' : null;
                    },
                  ),
                  CustomFormField(
                    autoValidate: true,
                    hintText: 'Password',
                    obscureText: _isObscured,
                    onSubmitted: (_) => _login,
                    textInputAction: TextInputAction.send,
                    icon: const Icon(
                      Icons.lock_outline_rounded,
                    ),
                    textEditingController: _passwordController,
                    validator: (val) {
                      return !val!.isValidPassword
                          ? 'Enter valid password'
                          : null;
                    },
                    onChanged: (_) => setState(() {}),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40)),
                        onPressed: () => _login(context),
                        child: const Text('Login')),
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        GoRouter.of(context).push(codeRegisterPath);
                      },
                      child: const Text('Join with Invitation Code')),
                ],
              ),
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ResponsiveVisibility(
                    visible: false,
                    visibleWhen: [
                      Condition.largerThan(
                        name: MOBILE,
                      ),
                    ],
                    child: AppLottieAnimation(loadingResource: 'apartment'),
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        GoRouter.of(context).push(registerPath);
                      },
                      child: const Text('Register')),
                  TextButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        GoRouter.of(context).push(forgotPasswordPath);
                      },
                      child: const Text('Forgot password')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

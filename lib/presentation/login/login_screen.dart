import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/register/register_screen.dart';

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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          return (!val!.isValidEmail)
                              ? 'Enter valid email'
                              : null;
                        },
                      ),
                      CustomFormField(
                        autoValidate: true,
                        hintText: 'Password',
                        obscureText: true,
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
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40)),
                          onPressed: () => _login(context),
                          child: const Text('Login')),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40)),
                          onPressed: () {
                            GoRouter.of(context).push(registerPath);
                          },
                          child: const Text('Join with Invitation Code')),
                    ],
                  ),
                ),
              ),
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                onPressed: () {
                  GoRouter.of(context).push(registerPath);
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}

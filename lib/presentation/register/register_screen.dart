import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../auth_cubit.dart';
import '../shared/custom_form_field.dart';

const registerPath = '/register';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  _register(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).createUser(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: const Text('Register'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _register(context),
          child: const Icon(Icons.chevron_right_outlined)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
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
                      return (!val!.isValidEmail) ? 'Enter valid email' : null;
                    },
                  ),
                  CustomFormField(
                    autoValidate: true,
                    hintText: 'Password',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
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
                  CustomFormField(
                    hintText: 'First name',
                    textInputAction: TextInputAction.next,
                    icon: const Icon(
                      Icons.badge_outlined,
                    ),
                    textEditingController: _firstNameController,
                  ),
                  CustomFormField(
                    hintText: 'Last name',
                    textInputAction: TextInputAction.next,
                    icon: const Icon(
                      Icons.badge_outlined,
                    ),
                    textEditingController: _lastNameController,
                  ),
                  CustomFormField(
                    hintText: 'Phone number',
                    textInputAction: TextInputAction.go,
                    icon: const Icon(
                      Icons.phone_iphone_outlined,
                    ),
                    textEditingController: _phoneController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

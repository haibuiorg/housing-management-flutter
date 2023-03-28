import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isObscured = true;

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
        title: Text(AppLocalizations.of(context).register),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _register(context),
          child: const Icon(Icons.chevron_right_outlined)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              textEditingController: _emailController,
              hintText: AppLocalizations.of(context).email,
              autoValidate: true,
              keyboardType: TextInputType.emailAddress,
              icon: const Icon(
                Icons.mail_outline_rounded,
              ),
              textInputAction: TextInputAction.next,
              validator: (val) {
                return (!val!.isValidEmail)
                    ? AppLocalizations.of(context).email_address_error
                    : null;
              },
            ),
            CustomFormField(
              autoValidate: true,
              hintText: AppLocalizations.of(context).password_title,
              obscureText: _isObscured,
              textInputAction: TextInputAction.next,
              icon: const Icon(
                Icons.lock_outline_rounded,
              ),
              textEditingController: _passwordController,
              validator: (val) {
                return !val!.isValidPassword
                    ? AppLocalizations.of(context).password_error
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
            CustomFormField(
              hintText: AppLocalizations.of(context).first_name,
              textInputAction: TextInputAction.next,
              icon: const Icon(
                Icons.badge_outlined,
              ),
              textEditingController: _firstNameController,
            ),
            CustomFormField(
              hintText: AppLocalizations.of(context).last_name,
              textInputAction: TextInputAction.next,
              icon: const Icon(
                Icons.badge_outlined,
              ),
              textEditingController: _lastNameController,
            ),
            CustomFormField(
              hintText: AppLocalizations.of(context).phone_number,
              textInputAction: TextInputAction.go,
              icon: const Icon(
                Icons.phone_iphone_outlined,
              ),
              textEditingController: _phoneController,
            ),
          ],
        ),
      ),
    );
  }
}

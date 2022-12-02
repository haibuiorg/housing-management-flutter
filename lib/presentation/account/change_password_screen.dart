import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../auth_cubit.dart';
import '../shared/app_lottie_animation.dart';
import '../shared/custom_form_field.dart';

const changePasswordPath = '/change_password';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  bool _isOldEmailObscure = true;
  bool _isNewEmailObscure = true;

  @override
  initState() {
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
  }

  _submitChangePassword() async {
    BlocProvider.of<AuthCubit>(context).changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        onError: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Password did not change'),
                  content: const Text(
                      'Something wrong with your password, please make sure you enter correct password and new password must be strong enough'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                );
              });
        },
        onSuccessful: () {
          showModalBottomSheet(
              context: context,
              isDismissible: false,
              useRootNavigator: true,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        const Text('Successfully change password'),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              BlocProvider.of<AuthCubit>(context).logOut();
                            },
                            child: const Text('OK'))
                      ],
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        actions: [
          TextButton(
            onPressed: _oldPasswordController.text.isValidPassword &&
                    _newPasswordController.text.isValidPassword
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text(
                                'When password successfully change, you will be logged out!'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _submitChangePassword();
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                : null,
            child: const Text('Change'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
                height: 200,
                width: 200,
                child: AppLottieAnimation(
                  loadingResource: 'change_password',
                )),
            Text(
              'Want to change your password?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                'Enter your old password and new password',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            CustomFormField(
              hintText: 'Old password',
              textEditingController: _oldPasswordController,
              autoValidate: true,
              obscureText: _isOldEmailObscure,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(_isOldEmailObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                      onPressed: () {
                        setState(() {
                          _isOldEmailObscure = !_isOldEmailObscure;
                        });
                      })),
              textInputAction: TextInputAction.next,
              validator: (val) {
                return (!val!.isValidPassword) ? 'Enter valid password' : null;
              },
            ),
            CustomFormField(
              hintText: 'New password',
              textEditingController: _newPasswordController,
              autoValidate: true,
              onChanged: (value) {
                setState(() {});
              },
              obscureText: _isNewEmailObscure,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(_isNewEmailObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                      onPressed: () {
                        setState(() {
                          _isNewEmailObscure = !_isNewEmailObscure;
                        });
                      })),
              textInputAction: TextInputAction.next,
              validator: (val) {
                return (!val!.isValidPassword)
                    ? 'Enter longer and stronger password'
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              builder: (builder) {
                return AlertDialog(
                  title: Text(
                      AppLocalizations.of(context)!.password_change_failed),
                  content: Text(AppLocalizations.of(context)!
                      .password_change_failed_detail),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(builder).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.ok))
                  ],
                );
              });
        },
        onSuccessful: () {
          showModalBottomSheet(
              context: context,
              isDismissible: false,
              useRootNavigator: true,
              builder: (builder) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!
                            .password_change_success),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(builder);
                              BlocProvider.of<AuthCubit>(context).logOut();
                            },
                            child: Text(AppLocalizations.of(context)!.ok))
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
        title: Text(AppLocalizations.of(context)!.change_password),
        actions: [
          TextButton(
            onPressed: _oldPasswordController.text.isValidPassword &&
                    _newPasswordController.text.isValidPassword
                ? () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.confirm),
                            content: Text(AppLocalizations.of(context)!
                                .password_change_success_detail),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _submitChangePassword();
                                    Navigator.pop(builder, true);
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.ok)),
                            ],
                          );
                        });
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.change),
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
              AppLocalizations.of(context)!.password_change_title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text(
                AppLocalizations.of(context)!.password_change_subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            CustomFormField(
              hintText: AppLocalizations.of(context)!.old_password,
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
                return (!val!.isValidPassword)
                    ? AppLocalizations.of(context)!.password_error
                    : null;
              },
            ),
            CustomFormField(
              hintText: AppLocalizations.of(context)!.new_password,
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
                    ? AppLocalizations.of(context)!.password_error
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

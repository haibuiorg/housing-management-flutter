import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/account/account_cubit.dart';
import 'package:priorli/presentation/account/account_state.dart';
import 'package:priorli/service_locator.dart';

import '../../auth_cubit.dart';
import '../shared/custom_form_field.dart';
import '../shared/setting_button.dart';
import 'change_password_screen.dart';

const accountPath = '/accounts';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final AccountCubit _cubit;
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cubit = serviceLocator<AccountCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    await _cubit.init();
    _firstNameController.text = _cubit.state.user?.firstName ?? '';
    _lastNameController.text = _cubit.state.user?.lastName ?? '';
    _phoneController.text = _cubit.state.user?.phone ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Account management'),
            actions: [
              TextButton(
                onPressed: state.user != state.pendingUser
                    ? () {
                        _cubit.saveNewUserDetail();
                      }
                    : null,
                child: const Text('Save'),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              CustomFormField(
                textEditingController: _firstNameController,
                hintText: 'First name',
                autofocus: false,
                onChanged: (value) => BlocProvider.of<AccountCubit>(context)
                    .updateFirstName(value),
                keyboardType: TextInputType.name,
              ),
              CustomFormField(
                hintText: 'Last name',
                textEditingController: _lastNameController,
                autofocus: false,
                onChanged: (value) => BlocProvider.of<AccountCubit>(context)
                    .updateLastName(value),
                keyboardType: TextInputType.name,
              ),
              CustomFormField(
                hintText: 'Phone number',
                textEditingController: _phoneController,
                autofocus: false,
                onChanged: (value) =>
                    BlocProvider.of<AccountCubit>(context).updatePhone(value),
                keyboardType: TextInputType.streetAddress,
              ),
              const Spacer(),
              SettingButton(
                label: const Text('Notification setting'),
                onPressed: () {
                  //GoRouter.of(context).push(paymentPath);
                },
              ),
              SettingButton(
                label: const Text('Change password'),
                onPressed: () {
                  GoRouter.of(context).push(changePasswordPath);
                },
              ),
              SettingButton(
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('Terms of use'),
                onPressed: () {
                  //GoRouter.of(context).push(paymentPath);
                },
              ),
              SettingButton(
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('Privacy policies'),
                onPressed: () {
                  //GoRouter.of(context).push(paymentPath);
                },
              ),
              SettingButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Do you want to log out?'),
                          content: Text(
                              'Are you sure want to log out of user: ${state.user?.firstName} ${state.user?.lastName}'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  BlocProvider.of<AuthCubit>(context).logOut();
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                },
                label: const Text('Logout'),
                icon: const Icon(Icons.logout),
              ),
            ]),
          ),
        );
      }),
    );
  }
}

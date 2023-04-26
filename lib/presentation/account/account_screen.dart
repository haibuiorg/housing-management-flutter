import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/presentation/account/account_cubit.dart';
import 'package:priorli/presentation/account/account_state.dart';
import 'package:priorli/presentation/shared/app_user_circle_avatar.dart';
import 'package:priorli/presentation/shared/full_width_pair_text.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/user_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../auth_cubit.dart';
import '../../user_cubit.dart';
import '../file_selector/file_selector.dart';
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
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppLocalizations.of(context)!.account_management),
            actions: [
              TextButton(
                onPressed: state.user != state.pendingUser
                    ? () async {
                        final user = await BlocProvider.of<UserCubit>(context)
                            .saveNewUserDetail(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                phone: _phoneController.text);
                        _cubit.updateUser(user);
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.save),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(children: [
                InkWell(
                  child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                    return AppUserCircleAvatar(
                      user: state.user,
                    );
                  }),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (builder) => Dialog(
                              child: FileSelector(
                                isSingleFile: true,
                                isImageOnly: true,
                                previewUrl: state.user?.avatarUrl,
                                onCompleteUploaded: (tempUploadedFiles) {
                                  BlocProvider.of<UserCubit>(context)
                                      .updateUserAvatar(tempUploadedFiles)
                                      .then((value) =>
                                          Navigator.pop(builder, true));
                                },
                              ),
                            ));
                  },
                ),
                FullWidthPairText(
                    label: AppLocalizations.of(context)!.email,
                    content: state.user?.email,
                    isBoldContent: true),
                CustomFormField(
                  textEditingController: _firstNameController,
                  hintText: AppLocalizations.of(context)!.first_name,
                  autofocus: false,
                  onChanged: (value) => BlocProvider.of<AccountCubit>(context)
                      .updateFirstName(value),
                  keyboardType: TextInputType.name,
                ),
                CustomFormField(
                  hintText: AppLocalizations.of(context)!.last_name,
                  textEditingController: _lastNameController,
                  autofocus: false,
                  onChanged: (value) => BlocProvider.of<AccountCubit>(context)
                      .updateLastName(value),
                  keyboardType: TextInputType.name,
                ),
                CustomFormField(
                  hintText: AppLocalizations.of(context)!.phone_number,
                  textEditingController: _phoneController,
                  autofocus: false,
                  onChanged: (value) =>
                      BlocProvider.of<AccountCubit>(context).updatePhone(value),
                  keyboardType: TextInputType.streetAddress,
                ),
                /*SettingButton(
                  label: Text(AppLocalizations.of(context)!.notification_setting)),
                  onPressed: () {
                    //GoRouter.of(context).push(paymentPath);
                  },
                ),*/
                SettingButton(
                  label: Text(AppLocalizations.of(context)!.change_password),
                  onPressed: () {
                    GoRouter.of(context).push(changePasswordPath);
                  },
                ),
                SettingButton(
                  icon: const Icon(Icons.open_in_new_outlined),
                  label: Text(AppLocalizations.of(context)!.terms_of_use),
                  onPressed: state.legalDocuments
                              ?.where((element) => element.type == 'terms') !=
                          null
                      ? () {
                          final terms = state.legalDocuments
                              ?.where((element) => element.type == 'terms')
                              .first;
                          final url = terms?.url ?? terms?.webUrl ?? appWebsite;
                          launchUrl(Uri.parse(url));
                        }
                      : null,
                ),
                SettingButton(
                  icon: const Icon(Icons.open_in_new_outlined),
                  label: Text(AppLocalizations.of(context)!.privacy_policies),
                  onPressed: state.legalDocuments?.where(
                              (element) => element.type == 'policies') !=
                          null
                      ? () {
                          final policies = state.legalDocuments
                              ?.where((element) => element.type == 'policies')
                              .first;
                          final url =
                              policies?.url ?? policies?.webUrl ?? appWebsite;
                          launchUrl(Uri.parse(url));
                        }
                      : null,
                ),
                SettingButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.logout_confirm),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(builder).pop();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel)),
                              TextButton(
                                  onPressed: () {
                                    BlocProvider.of<AuthCubit>(context)
                                        .logOut();
                                  },
                                  child: Text(AppLocalizations.of(context)!.ok))
                            ],
                          );
                        });
                  },
                  label: Text(AppLocalizations.of(context)!.logout),
                  icon: const Icon(Icons.logout),
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }
}

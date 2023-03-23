import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../company_user_management/company_user_screen.dart';
import '../housing_company_payment/housing_company_payment_screen.dart';
import '../housing_company_subscription/company_subscription_screen.dart';
import '../housing_company_ui/housing_company_ui_screen.dart';
import '../send_invitation/invite_tenant_screen.dart';
import '../shared/setting_button.dart';
import 'housing_company_management_cubit.dart';
import 'housing_company_management_state.dart';

const manageScreenPath = 'manage';

class HousingCompanyManagementScreen extends StatefulWidget {
  const HousingCompanyManagementScreen({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<HousingCompanyManagementScreen> createState() =>
      _HousingCompanyManagementScreenState();
}

class _HousingCompanyManagementScreenState
    extends State<HousingCompanyManagementScreen> {
  final HousingCompanyManagementCubit cubit =
      serviceLocator<HousingCompanyManagementCubit>();
  final _companyName = TextEditingController();
  final _streetAddress1 = TextEditingController();
  final _streetAddress2 = TextEditingController();
  final _postalCode = TextEditingController();
  final _city = TextEditingController();
  final _businessId = TextEditingController();

  @override
  void dispose() {
    _companyName.dispose();
    _streetAddress1.dispose();
    _streetAddress2.dispose();
    _postalCode.dispose();
    _city.dispose();
    _businessId.dispose();
    cubit.close();
    super.dispose();
  }

  _showConfirmDeleteDialog(Function() onDismiss) async {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
              "Are you sure you wish to delete this housing company?"),
          actions: [
            OutlinedButton(onPressed: onDismiss, child: const Text("Delete")),
            TextButton(
              onPressed: () => Navigator.of(builder).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.init(widget.companyId).then((state) {
        _companyName.text = state.housingCompany?.name ?? '';
        _streetAddress1.text = state.housingCompany?.streetAddress1 ?? '';
        _streetAddress2.text = state.housingCompany?.streetAddress2 ?? '';
        _postalCode.text = state.housingCompany?.postalCode ?? '';
        _city.text = state.housingCompany?.city ?? '';
        _businessId.text = state.housingCompany?.businessId ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HousingCompanyManagementCubit>(
      create: (_) => cubit,
      child: BlocConsumer<HousingCompanyManagementCubit,
          HousingCompanyManagementState>(listener: (context, state) {
        if (state.housingCompanyDeleted == true) {
          GoRouter.of(context).go(mainPath);
        }
      }, builder: (context, state) {
        return state.housingCompany?.isUserManager == true
            ? Scaffold(
                appBar: AppBar(
                  actions: [
                    TextButton(
                      onPressed: state.housingCompany !=
                              state.pendingUpdateHousingCompany
                          ? () {
                              cubit.saveNewCompanyDetail();
                            }
                          : null,
                      child: const Text('Save'),
                    )
                  ],
                  title: const Text('Manage'),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          CustomFormField(
                            textEditingController: _companyName,
                            hintText: 'Company name',
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateCompanyName(value),
                            keyboardType: TextInputType.name,
                          ),
                          CustomFormField(
                            hintText: 'Street address 1',
                            textEditingController: _streetAddress1,
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateStreetAddress1(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: 'Street address 2',
                            textEditingController: _streetAddress2,
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateStreetAddress2(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: 'Postal code',
                            textEditingController: _postalCode,
                            autofocus: false,
                            onChanged: (value) => cubit.updatePostalCode(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: 'City',
                            textEditingController: _city,
                            autofocus: false,
                            onChanged: (value) => cubit.updateCity(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Country: ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                state.housingCompany?.countryCode != null
                                    ? Text(
                                        EmojiParser().emojify(
                                            ':flag-${state.housingCompany?.countryCode}:'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )
                                    : const Text('No data')
                              ],
                            ),
                          ),
                          CustomFormField(
                            hintText: 'Business Id',
                            textEditingController: _businessId,
                            autofocus: false,
                            onChanged: (value) => cubit.updateCity(value),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox.fromSize(
                            size: const Size.fromHeight(56),
                          ),
                          if (kIsWeb)
                            SettingButton(
                              onPressed: () {
                                context.pushFromCurrentLocation(
                                    companySubscriptionScreenPath);
                              },
                              label: Text(
                                'Subscription',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(
                                  housingCompanyPaymentPath);
                            },
                            label: Text(
                              'Payment and bank account detail',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(companyUserPath);
                            },
                            label: Text(
                              'User management',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(
                                  housingCompanyUiScreenPath);
                            },
                            label: Text(
                              'Appearance',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SettingButton(
                            onPressed: () async {
                              _showConfirmDeleteDialog(() {
                                cubit.deleteThisHousingCompany();
                              });
                            },
                            label: Text(
                              'Delete this company',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size.fromHeight(56),
                          )
                        ]),
                      ),
                    ),
                  ],
                ))
            : const AppLottieAnimation(loadingResource: 'apartment');
      }),
    );
  }
}

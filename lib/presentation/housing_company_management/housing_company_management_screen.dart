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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context).remove),
          content: Text(AppLocalizations.of(context).remove_company_confirm),
          actions: [
            OutlinedButton(
                onPressed: onDismiss,
                child: Text(AppLocalizations.of(context).confirm)),
            TextButton(
              onPressed: () => Navigator.of(builder).pop(false),
              child: Text(AppLocalizations.of(context).cancel),
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
                      child: Text(
                        AppLocalizations.of(context).save,
                      ),
                    )
                  ],
                  title: Text(
                    AppLocalizations.of(context).manange,
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          CustomFormField(
                            textEditingController: _companyName,
                            hintText:
                                AppLocalizations.of(context).company_name_title,
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateCompanyName(value),
                            keyboardType: TextInputType.name,
                          ),
                          CustomFormField(
                            hintText: AppLocalizations.of(context)
                                .street_address_line1,
                            textEditingController: _streetAddress1,
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateStreetAddress1(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: AppLocalizations.of(context)
                                .street_address_line2,
                            textEditingController: _streetAddress2,
                            autofocus: false,
                            onChanged: (value) =>
                                cubit.updateStreetAddress2(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: AppLocalizations.of(context).postal_code,
                            textEditingController: _postalCode,
                            autofocus: false,
                            onChanged: (value) => cubit.updatePostalCode(value),
                            keyboardType: TextInputType.streetAddress,
                          ),
                          CustomFormField(
                            hintText: AppLocalizations.of(context).city,
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
                                  AppLocalizations.of(context)
                                      .country_with_name(state
                                              .housingCompany?.countryCode ??
                                          AppLocalizations.of(context).no_data),
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
                                    : Text(
                                        AppLocalizations.of(context).no_data),
                              ],
                            ),
                          ),
                          CustomFormField(
                            hintText: AppLocalizations.of(context).business_id,
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
                                AppLocalizations.of(context).subscription,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(
                                  housingCompanyPaymentPath);
                            },
                            label: Text(
                              AppLocalizations.of(context).payment_bank_account,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(companyUserPath);
                            },
                            label: Text(
                              AppLocalizations.of(context).user_management,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SettingButton(
                            onPressed: () {
                              context.pushFromCurrentLocation(
                                  housingCompanyUiScreenPath);
                            },
                            label: Text(
                              AppLocalizations.of(context).company_branding,
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
                              AppLocalizations.of(context)
                                  .delete_housing_company,
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

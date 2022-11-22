import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../send_invitation/invite_tenant_screen.dart';
import '../shared/setting_button.dart';
import 'housing_company_management_cubit.dart';
import 'housing_company_management_state.dart';

const manageScreenPath = 'manage';

class HousingCompanyManagementScreen extends StatefulWidget {
  const HousingCompanyManagementScreen({super.key});

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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final housingCompanyId =
          Uri.parse(GoRouter.of(context).location).pathSegments[1];
      cubit.init(housingCompanyId).then((state) {
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
      child: BlocBuilder<HousingCompanyManagementCubit,
          HousingCompanyManagementState>(builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed:
                      state.housingCompany != state.pendingUpdateHousingCompany
                          ? () {
                              cubit.saveNewCompanyDetail();
                            }
                          : null,
                  child: const Text('Save'),
                )
              ],
              title: const Text('Manage'),
            ),
            body: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        CustomFormField(
                          textEditingController: _companyName,
                          hintText: 'Company name',
                          autofocus: false,
                          onChanged: (value) => cubit.updateCompanyName(value),
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
                              Text(
                                EmojiParser().emojify(
                                    ':flag-${state.housingCompany?.countryCode}:'),
                                style: Theme.of(context).textTheme.displaySmall,
                              )
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
                      ]),
                    ),
                  ),
                  SettingButton(
                    onPressed: () {},
                    label: Text(
                      'Edit location',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SettingButton(
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$inviteTenantPath');
                    },
                    label: Text(
                      'Send invitation to an apartment',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SettingButton(
                    onPressed: () async {
                      final result = await cubit.deleteThisHousingCompany();
                      if (result) {
                        if (!context.mounted) return;
                        context.go(mainPath);
                      }
                    },
                    label: Text(
                      'Delete this company',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}

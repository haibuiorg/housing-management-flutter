import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_cubit.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../housing_company/housing_company_screen.dart';

const createCompanyPath = '/create_company';

class CreateHousingCompanyScreen extends StatelessWidget {
  const CreateHousingCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateHousingCompanyCubit>(
      create: (_) => serviceLocator<CreateHousingCompanyCubit>()..init(),
      child: BlocConsumer<CreateHousingCompanyCubit, CreateHousingCompanyState>(
          listener: (context, state) {
        if (state.newCompanyId != null &&
            state.newCompanyId?.isNotEmpty == true) {
          Navigator.of(context).pop();
          GoRouter.of(context)
              .push('/$housingCompanyScreenPath/${state.newCompanyId}');
        }
      }, builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: state.companyName?.isNotEmpty == true &&
                      state.selectedCountryCode?.isNotEmpty == true
                  ? () {
                      BlocProvider.of<CreateHousingCompanyCubit>(context)
                          .createHousingCompany();
                    }
                  : null,
              child: const Icon(Icons.navigate_next)),
          appBar: AppBar(
            title:
                Text(AppLocalizations.of(context).create_a_housing_community),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveValue(
                            context,
                            defaultValue: MediaQuery.of(context).size.width / 6,
                            valueWhen: [
                              const Condition.smallerThan(
                                name: MOBILE,
                                value: 16.0,
                              ),
                              Condition.smallerThan(
                                name: TABLET,
                                value: MediaQuery.of(context).size.width / 4,
                              ),
                            ],
                          ).value ??
                          16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            AppLocalizations.of(context)
                                .what_is_your_housing_community_name,
                            textAlign: TextAlign.center),
                        CustomFormField(
                          validator: (p0) => (state.errorText != null)
                              ? state.errorText
                              : null,
                          onChanged: (value) =>
                              BlocProvider.of<CreateHousingCompanyCubit>(
                                      context)
                                  .onTypingName(value),
                          hintText: AppLocalizations.of(context).name_title,
                          textCapitalization: TextCapitalization.words,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context).country),
                            ),
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                children: List.generate(
                                    state.countryList?.length ?? 0, (index) {
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(2.0),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flag.fromString(
                                          state.countryList?[index].countryCode
                                                  .toLowerCase() ??
                                              'fi',
                                          height: 24,
                                          width: 24,
                                          flagSize: FlagSize.size_1x1,
                                          borderRadius: 4,
                                        ),
                                        SizedBox.fromSize(
                                          size: const Size(4, 4),
                                        ),
                                        Text(CountryLocalizations.of(context)
                                                ?.countryName(
                                                    countryCode: state
                                                            .countryList?[index]
                                                            .countryCode
                                                            .toLowerCase() ??
                                                        'fi') ??
                                            state
                                                .countryList?[index].countryCode
                                                .toLowerCase() ??
                                            'fi'),
                                      ],
                                    ),
                                    selected: state
                                            .countryList?[index].countryCode
                                            .toLowerCase() ==
                                        state.selectedCountryCode
                                            ?.toLowerCase(),
                                    onSelected: (value) {
                                      BlocProvider.of<
                                                  CreateHousingCompanyCubit>(
                                              context)
                                          .selectCountry(state
                                              .countryList?[index].countryCode);
                                    },
                                    elevation: 1,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        const AccountTypeSelector(),
                      ]),
                ),
        );
      }),
    );
  }
}

class AccountTypeSelector extends StatefulWidget {
  const AccountTypeSelector({super.key});

  @override
  State<AccountTypeSelector> createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<AccountTypeSelector> {
  bool isBusiness = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context).account_type),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: isBusiness,
              onChanged: (value) {
                setState(() {
                  isBusiness = value as bool;
                });
              },
            ),
            Text(AppLocalizations.of(context).individual),
          ],
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: isBusiness,
              onChanged: (value) {
                setState(() {
                  isBusiness = value as bool;
                });
              },
            ),
            Text(AppLocalizations.of(context).company),
          ],
        ),
        if (isBusiness)
          CustomFormField(
            hintText: AppLocalizations.of(context).business_id,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              BlocProvider.of<CreateHousingCompanyCubit>(context)
                  .onTypingBusinessId(value);
            },
          )
      ],
    );
  }
}

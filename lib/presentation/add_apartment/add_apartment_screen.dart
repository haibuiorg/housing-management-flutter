import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/add_apartment/add_apart_state.dart';
import 'package:priorli/presentation/apartments/apartment_screen.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/number_formatters.dart';
import '../../go_router_navigation.dart';
import 'add_apart_cubit.dart';

const addApartmentPath = 'add_apartment';

class AddApartmentScreen extends StatelessWidget {
  const AddApartmentScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;
  @override
  Widget build(BuildContext context) {
    final cubit = serviceLocator<AddApartmentCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider<AddApartmentCubit>(
      create: (_) => cubit,
      child: BlocConsumer<AddApartmentCubit, AddApartmentState>(
          listener: ((context, state) {
        if (state.addedApartments != null) {
          context.pushFromCurrentLocation(
              '$apartmentScreenPath/${state.addedApartments?.first.id}}');
        }
        if (state.errorText != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorText ?? ''),
          ));
        }
      }), builder: (context, state) {
        return (state.housingCompany?.isUserManager == true)
            ? Scaffold(
                floatingActionButton: OutlinedButton(
                    onPressed: ((state.building?.length ?? 0) == 0 ||
                            (state.houseCodes?.contains('') == true &&
                                (state.houseCodes?.length ?? 0) > 1))
                        ? null
                        : () => cubit.addApartments(),
                    child: const Icon(Icons.chevron_right_outlined)),
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context).add_apartment(
                      state.housingCompany?.name ??
                          AppLocalizations.of(context).housing_companies)),
                ),
                body: Column(children: [
                  CustomFormField(
                    textCapitalization: TextCapitalization.sentences,
                    hintText: AppLocalizations.of(context).building_name,
                    onChanged: (value) => cubit.updateBuilding(value),
                  ),
                  CustomFormField(
                    hintText: AppLocalizations.of(context)
                        .number_of_apartment_in_building,
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (value) => cubit.updateHouseCode(int.tryParse(
                          value,
                        ) ??
                        1),
                  ),
                  FullWidthTitle(
                    title:
                        AppLocalizations.of(context).autofill_apartment_number,
                    action: Switch(
                        value: state.automaticHouseCodeInput != false,
                        onChanged: (onChanged) => cubit
                            .updateAutomaticFillApartmentNumber(onChanged)),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: (state.houseCodes?.length ?? 0) > 1 &&
                                  state.automaticHouseCodeInput == false
                              ? state.houseCodes?.length
                              : 0,
                          itemBuilder: ((context, index) {
                            return CustomFormField(
                              hintText: AppLocalizations.of(context)
                                  .aparment_house_number,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              onChanged: (value) =>
                                  cubit.updateHouseCodeDetail(index, value),
                            );
                          })))
                ]),
              )
            : const AppLottieAnimation(
                loadingResource: 'apartment',
              );
      }),
    );
  }
}

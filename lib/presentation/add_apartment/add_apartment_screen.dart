import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/add_apartment/add_apart_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';

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
          Navigator.of(context)
              .popUntil(ModalRoute.withName(housingCompanyScreenPathName));
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
                  title: Text(
                      'Add apartments to ${state.housingCompany?.name ?? 'housing company'}'),
                ),
                body: Column(children: [
                  CustomFormField(
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'Building name',
                    onChanged: (value) => cubit.updateBuilding(value),
                  ),
                  CustomFormField(
                    hintText: 'Number of apartments/houses in this Building',
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (value) => cubit.updateHouseCode(int.parse(
                      value,
                    )),
                  ),
                  FullWidthTitle(
                    title: 'Autofill apartment numebers',
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
                              hintText: 'Apartment/House number',
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

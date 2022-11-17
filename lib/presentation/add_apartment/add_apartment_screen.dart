import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/add_apartment/add_apart_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';

import 'add_apart_cubit.dart';

const addApartmentPath = 'add_apartment';

class AddApartmentScreen extends StatelessWidget {
  const AddApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    final cubit = serviceLocator<AddApartmentCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider<AddApartmentCubit>(
      create: (_) => cubit,
      child: BlocBuilder<AddApartmentCubit, AddApartmentState>(
          builder: (context, state) {
        return Scaffold(
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
              hintText: 'Building name',
              onChanged: (value) => cubit.updateBuilding(value),
            ),
            CustomFormField(
              hintText: 'Number of apartments/houses in this Building',
              keyboardType: const TextInputType.numberWithOptions(),
              onChanged: (value) => cubit.updateHouseCode(int.parse(
                value,
                onError: (_) => 1,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Automatically fill apartment/house with numbers'),
                Switch(
                    value: state.automaticHouseCodeInput != false,
                    onChanged: (onChanged) =>
                        cubit.updateAutomaticFillApartmentNumber(onChanged)),
              ],
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
                        keyboardType: const TextInputType.numberWithOptions(),
                        onChanged: (value) =>
                            cubit.updateHouseCodeDetail(index, value),
                      );
                    })))
          ]),
        );
      }),
    );
  }
}

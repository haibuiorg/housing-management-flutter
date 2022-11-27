import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_cubit.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_state.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';

import '../housing_company/housing_company_screen.dart';

const createCompanyPath = '/create_company';

class CreateHousingCompanyScreen extends StatelessWidget {
  const CreateHousingCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CreateHousingCompanyCubit>(
        create: (_) => serviceLocator<CreateHousingCompanyCubit>(),
        child:
            BlocConsumer<CreateHousingCompanyCubit, CreateHousingCompanyState>(
                listener: (context, state) {
          if (state.newCompanyId != null &&
              state.newCompanyId?.isNotEmpty == true) {
            Navigator.of(context).popUntil(ModalRoute.withName(mainPath));
            GoRouter.of(context)
                .push('$housingCompanyScreenPath/${state.newCompanyId}');
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('What is your housing commmunity called?'),
              CustomFormField(
                validator: (p0) =>
                    (state.errorText != null) ? state.errorText : null,
                onSubmitted: (value) =>
                    BlocProvider.of<CreateHousingCompanyCubit>(context)
                        .createHousingCompany(),
                onChanged: (value) =>
                    BlocProvider.of<CreateHousingCompanyCubit>(context)
                        .onTypingName(value),
                hintText: 'Company name',
              ),
              OutlinedButton(
                  onPressed: state.companyName?.isNotEmpty == true
                      ? () {
                          BlocProvider.of<CreateHousingCompanyCubit>(context)
                              .createHousingCompany();
                        }
                      : null,
                  child: const Text('Next'))
            ]),
          );
        }),
      ),
    );
  }
}

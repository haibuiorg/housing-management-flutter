import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';
import 'package:priorli/service_locator.dart';

import '../send_invitation/invite_tenant_screen.dart';

const housingCompanyScreenPath = '/housing_company';

class HousingCompanyScreen extends StatelessWidget {
  const HousingCompanyScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;

  @override
  Widget build(BuildContext context) {
    final cubit = serviceLocator<HousingCompanyCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider<HousingCompanyCubit>(
      create: (_) => cubit,
      child: BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
          builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.housingCompany?.name ?? 'Housing company'),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                OutlinedButton(
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$addApartmentPath');
                    },
                    child: const Text('Add apartments')),
                OutlinedButton(
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$inviteTenantPath');
                    },
                    child: const Text('Send invitation to an apartment'))
              ]),
            ));
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/home/main_cubit.dart';
import 'package:priorli/presentation/home/main_state.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';

import 'housing_company_tile.dart';

class SelectableCompanyList extends StatelessWidget {
  const SelectableCompanyList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                BlocProvider.of<MainCubit>(context).getUserHousingCompanies(),
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () => GoRouter.of(context).push(
                      '$housingCompanyScreenPath/${state.housingCompanies?[index].id}'),
                  child: HousingCompanyTile(
                    housingCompany: state.housingCompanies?[index],
                  ),
                );
              }),
              itemCount: state.housingCompanies?.length ?? 0,
            ),
          ),
        );
      },
    );
  }
}

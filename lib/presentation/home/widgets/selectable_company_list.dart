import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/home/home_cubit.dart';

import '../home_state.dart';
import 'housing_company_tile.dart';

class SelectableCompanyList extends StatelessWidget {
  const SelectableCompanyList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () =>
              BlocProvider.of<HomeCubit>(context).getUserHousingCompanies(),
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return HousingCompanyTile(
                housingCompany: state.housingCompanies?[index],
              );
            }),
            itemCount: state.housingCompanies?.length ?? 0,
          ),
        );
      },
    );
  }
}

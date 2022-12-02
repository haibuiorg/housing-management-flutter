import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/utils/color_extension.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';

import '../../../core/utils/constants.dart';

class HousingCompanyTile extends StatelessWidget {
  const HousingCompanyTile({super.key, required this.housingCompany});
  final HousingCompany? housingCompany;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Container(
        height: 100,
        margin: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(minHeight: 160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorScheme.fromSeed(
                  seedColor: HexColor.fromHex(
                      housingCompany?.ui.seedColor ?? appSeedColor),
                  brightness: state.brightness ?? Brightness.dark)
              .onPrimary,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          housingCompany?.logoUrl.isNotEmpty == true
              ? CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(housingCompany?.logoUrl ?? ''),
                )
              : CircleAvatar(
                  radius: 36,
                  child: Text(
                    housingCompany?.name.characters.first.toUpperCase() ?? 'H',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(housingCompany?.name.capitalize() ?? ''),
          ),
          Text(
              '${housingCompany?.streetAddress1} ${housingCompany?.streetAddress2} ${housingCompany?.postalCode} ${housingCompany?.city}')
        ]),
      );
    });
  }
}

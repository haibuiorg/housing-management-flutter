import 'package:flutter/material.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/utils/color_extension.dart';

import '../../../core/utils/constant.dart';

class HousingCompanyTile extends StatelessWidget {
  const HousingCompanyTile({super.key, required this.housingCompany});
  final HousingCompany? housingCompany;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: HexColor.fromHex(housingCompany?.ui.seedColor ?? appSeedColor),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(
          radius: 38,
          backgroundImage: NetworkImage(housingCompany?.logoUrl ?? ''),
        ),
        Text(housingCompany?.name ?? ''),
        Text(
            '${housingCompany?.streetAddress1} ${housingCompany?.streetAddress2} ${housingCompany?.postalCode} ${housingCompany?.city}')
      ]),
    );
  }
}

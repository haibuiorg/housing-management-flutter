import 'package:flutter/material.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class HousingCompanyTile extends StatelessWidget {
  const HousingCompanyTile({super.key, required this.housingCompany});
  final HousingCompany? housingCompany;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(children: [
        Text(housingCompany?.name ?? ''),
        Text(housingCompany?.streetAddress1 ?? '')
      ]),
    );
  }
}

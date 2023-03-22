import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/shared/tap_card.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';

import '../../../core/utils/color_extension.dart';
import '../../../core/utils/constants.dart';
import '../../housing_company/housing_company_screen.dart';

class HousingCompanyTile extends StatelessWidget {
  const HousingCompanyTile({super.key, required this.housingCompany});
  final HousingCompany? housingCompany;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TapCard(
          onTap: () => context.pushFromCurrentLocation(
              '$housingCompanyScreenPath/${housingCompany?.id}'),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: housingCompany?.ui?.seedColor != null
                    ? HexColor.fromHex(
                        housingCompany?.ui?.seedColor ?? appSeedColor)
                    : Theme.of(context).colorScheme.primary,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: housingCompany?.coverImageUrl != null
                        ? CachedNetworkImageProvider(
                            housingCompany?.coverImageUrl ?? '')
                        : Image.asset('').image)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    housingCompany?.logoUrl.isNotEmpty == true
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: CachedNetworkImageProvider(
                                housingCompany?.logoUrl ?? ''),
                          )
                        : CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            radius: 36,
                            child: Text(
                              housingCompany?.name.characters.first
                                      .toUpperCase() ??
                                  'H',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                      child: Text(
                        housingCompany?.name ?? 'Housing company',
                      ),
                    ),
                    Text(
                        '${housingCompany?.streetAddress1} ${housingCompany?.streetAddress2} ${housingCompany?.postalCode} ${housingCompany?.city}')
                  ]),
            ),
          ),
        ),
      );
    });
  }
}

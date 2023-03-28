import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'invite_tenant_cubit.dart';

const inviteTenantPath = 'invite';

class InviteTenantScreen extends StatelessWidget {
  const InviteTenantScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;

  @override
  Widget build(BuildContext context) {
    final cubit = serviceLocator<InviteTenantCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<InviteTenantCubit, InviteTenantState>(
          listener: (context, state) {
        if (state.popNow == true) {
          Navigator.pop(context, true);
        }
      }, builder: (context, state) {
        return Scaffold(
          floatingActionButton: OutlinedButton(
              onPressed: state.emails?.isNotEmpty == true &&
                      state.selectedApartment?.isNotEmpty == true
                  ? () async => cubit.sendInvitation()
                  : null,
              child: const Icon(Icons.chevron_right_outlined)),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).send_invitation),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownSearch<Apartment>(
                  items: state.apartmentList ?? [],
                  popupProps: PopupProps.menu(
                    showSearchBox: (state.apartmentList?.length ?? 0) > 20,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).select_apartment)),
                  itemAsString: (Apartment apartment) =>
                      '${apartment.building} ${apartment.houseCode ?? ''}',
                  onChanged: (Apartment? apartment) =>
                      cubit.setSelectedApartmentId(apartment?.id ?? ''),
                ),
              ),
              CustomFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => cubit.updateEmails(value),
                hintText: AppLocalizations.of(context).email_list_hint,
              ),
            ],
          )),
        );
      }),
    );
  }
}

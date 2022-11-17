import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'invite_tenant_cubit.dart';

const inviteTenantPath = 'invite';

class InviteTenantScreen extends StatelessWidget {
  const InviteTenantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    final cubit = serviceLocator<InviteTenantCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<InviteTenantCubit, InviteTenantState>(
          builder: (context, state) {
        return Scaffold(
          floatingActionButton: OutlinedButton(
              onPressed: state.emails?.isNotEmpty == true &&
                      state.numberOfInvitations > 0 &&
                      state.selectedApartment?.isNotEmpty == true
                  ? () async => cubit.sendInvitation()
                  : null,
              child: const Icon(Icons.chevron_right_outlined)),
          appBar: AppBar(
            title: const Text('Send invitation'),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              DropdownSearch<Apartment>(
                items: state.apartmentList ?? [],
                popupProps: PopupProps.menu(
                  showSearchBox: (state.apartmentList?.length ?? 0) > 20,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration:
                        InputDecoration(labelText: 'To apartment')),
                itemAsString: (Apartment apartment) =>
                    '${apartment.building} ${apartment.houseCode ?? ''}',
                onChanged: (Apartment? apartment) =>
                    cubit.setSelectedApartmentId(apartment?.id ?? ''),
              ),
              CustomFormField(
                keyboardType: const TextInputType.numberWithOptions(),
                initialValue: state.numberOfInvitations.toString(),
                onChanged: (value) =>
                    cubit.updateNumberOfInvitation(int.parse(value)),
                hintText: 'Number of invitation',
              ),
              CustomFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => cubit.updateEmails(value),
                hintText: 'Emails to send invitation to (separate with ; or ,)',
              ),
            ],
          )),
        );
      }),
    );
  }
}

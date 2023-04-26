import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'admin_cubit.dart';
import 'admin_state.dart';

class ContactLeadListView extends StatelessWidget {
  const ContactLeadListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
      return ListView.builder(
          itemCount: state.contactLeadList?.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectionArea(
                child: ListTile(
                  onTap: () {},
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {},
                  ),
                  tileColor: state.contactLeadList![index].type == 'demo_form'
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : Theme.of(context).cardColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  title: Text(AppLocalizations.of(context)!.contact_lead_detail(
                      state.contactLeadList![index].name,
                      state.contactLeadList![index].email,
                      state.contactLeadList![index].phone)),
                  subtitle: Text(AppLocalizations.of(context)!
                      .message(state.contactLeadList![index].message)),
                  leading: state.contactLeadList![index].type == 'contact_form'
                      ? const Icon(Icons.contact_mail_rounded)
                      : state.contactLeadList![index].type == 'demo_form'
                          ? const Icon(Icons.calendar_month_rounded)
                          : const Icon(Icons.percent_rounded),
                ),
              ),
            );
          });
    });
  }
}

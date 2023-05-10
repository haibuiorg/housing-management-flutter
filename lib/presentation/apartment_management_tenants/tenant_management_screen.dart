import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/apartment_management_tenants/tenant_management_cubit.dart';
import 'package:priorli/presentation/apartment_management_tenants/tenant_management_state.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/user/entities/user.dart';
import '../shared/app_user_circle_avatar.dart';

const tenantManagementPath = 'tenant-management';

class TenantManagementScreen extends StatelessWidget {
  const TenantManagementScreen(
      {super.key, required this.companyId, required this.apartmentId});
  final String companyId;
  final String apartmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<TenantManagmentCubit>(
        create: (_) => serviceLocator()..init(companyId, apartmentId),
        child: BlocBuilder<TenantManagmentCubit, TenantManagementState>(
            builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _createDataTable(
                      context: context,
                      userList: state.tenants ?? [],
                      owners: state.owners ?? [],
                      limit: state.limit ?? 4),
                  FullWidthTitle(
                      title: AppLocalizations.of(context)!.pending_invitations),
                  const ApartmentInvitationListView(
                    isVertical: false,
                  ),
                  SettingButton(
                    label: Text(AppLocalizations.of(context)!.invite_tenants),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builderContext) {
                            return Dialog(
                              child: InviteTenantScreen(
                                  housingCompanyId: companyId,
                                  apartmentId: apartmentId),
                            );
                          });
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  PaginatedDataTable _createDataTable(
      {required BuildContext context,
      required List<User> userList,
      required List<String> owners,
      int? limit}) {
    return PaginatedDataTable(
        header: Text(AppLocalizations.of(context)!.tenants),
        rowsPerPage: limit ?? 5,
        columns: _createColumns(context),
        source: TenantDataTableSource(
            context: context, userList: userList, owners: owners));
  }

  List<DataColumn> _createColumns(BuildContext context) {
    return [
      const DataColumn(label: Text('')),
      DataColumn(label: Text(AppLocalizations.of(context)!.email)),
      DataColumn(label: Text(AppLocalizations.of(context)!.first_name)),
      DataColumn(label: Text(AppLocalizations.of(context)!.last_name)),
      DataColumn(label: Text(AppLocalizations.of(context)!.phone_number)),
      DataColumn(label: Text(AppLocalizations.of(context)!.role)),
      const DataColumn(label: Text('')),
    ];
  }
}

class ApartmentInvitationListView extends StatelessWidget {
  const ApartmentInvitationListView({
    super.key,
    required this.isVertical,
  });

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantManagmentCubit, TenantManagementState>(
        builder: (context, state) {
      final apartmentInvitationList = state.pendingInvitations ?? [];
      return SizedBox.fromSize(
        size: Size.fromHeight(isVertical ? 200 : 120),
        child: ListView.builder(
            scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                  width: isVertical ? double.maxFinite : 250,
                  child: Center(
                    child: Card(
                      child: ListTile(
                        isThreeLine: false,
                        subtitle: Text(AppLocalizations.of(context)
                                ?.number_of_email_sent(
                                    apartmentInvitationList[index]
                                        .emailSent
                                        .toString()) ??
                            ""),
                        title: Text(
                          AppLocalizations.of(context)?.email_sent_to(
                                  apartmentInvitationList[index]
                                      .email
                                      .toString()) ??
                              "",
                        ),
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!
                                      .resend_invitation),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .email_sent_to(
                                              apartmentInvitationList[index]
                                                  .email
                                                  .toString())),
                                      ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<TenantManagmentCubit>(
                                                  context)
                                              .resendApartmentInvitation(
                                                  apartmentInvitationList[index]
                                                      .id)
                                              .then((value) =>
                                                  Navigator.pop(builder));
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .confirm),
                                      ),
                                    ],
                                  ),
                                );
                              })
                        },
                      ),
                    ),
                  ));
            },
            itemCount: apartmentInvitationList.length),
      );
    });
  }
}

class TenantDataTableSource extends DataTableSource {
  final List<User> userList;
  final List<String> owners;
  final BuildContext context;

  TenantDataTableSource(
      {required this.context, required this.userList, required this.owners});
  @override
  DataRow? getRow(int index) {
    final user = userList[index];
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppUserCircleAvatar(
          user: user,
          radius: 16,
        ),
      )),
      DataCell(Text(user.email)),
      DataCell(Text(user.firstName)),
      DataCell(Text(user.lastName)),
      DataCell(Text(user.phone)),
      DataCell(
        Text(owners.contains(user.userId)
            ? AppLocalizations.of(context)!.owner
            : AppLocalizations.of(context)!.tenant),
      ),
      DataCell(Container(), onTap: () {
        showDialog(
            context: context,
            builder: (builderContext) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SettingButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (innerDialog) {
                              return AlertDialog(
                                  content: Text(AppLocalizations.of(context)!
                                      .change_role_to(owners
                                              .contains(user.userId)
                                          ? AppLocalizations.of(context)!.tenant
                                          : AppLocalizations.of(context)!
                                              .owner)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(builderContext).pop();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel)),
                                    TextButton(
                                        onPressed: () {
                                          BlocProvider.of<TenantManagmentCubit>(
                                                  context)
                                              .changeRole(user.userId)
                                              .then((value) {
                                            Navigator.of(innerDialog).pop();
                                            Navigator.of(builderContext).pop();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .confirm))
                                  ]);
                            });
                      },
                      label: Text(AppLocalizations.of(context)!.change_role_to(
                          owners.contains(user.userId)
                              ? AppLocalizations.of(context)!.tenant
                              : AppLocalizations.of(context)!.owner)),
                    ),
                    SettingButton(
                      label: Text(AppLocalizations.of(context)!.remove_this_tenant(
                          "${user.firstName} ${user.lastName}, ${user.email}")),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (innerDialog) {
                              return AlertDialog(
                                  content: Text(AppLocalizations.of(context)!
                                      .remove_this_tenant(
                                          "${user.firstName} ${user.lastName}, ${user.email}")),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(builderContext).pop();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel)),
                                    TextButton(
                                        onPressed: () {
                                          BlocProvider.of<TenantManagmentCubit>(
                                                  context)
                                              .removeTenant(user.userId)
                                              .then((value) {
                                            Navigator.of(innerDialog).pop();
                                            Navigator.of(builderContext).pop();
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .confirm))
                                  ]);
                            });
                      },
                    ),
                  ],
                ),
              );
            });
      }, showEditIcon: true)
    ]);
  }

  // for now its not paginate
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.length;

  @override
  int get selectedRowCount => 0;
}

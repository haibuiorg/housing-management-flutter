import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/company_user_management/manager_creation_form.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/user/entities/user.dart';
import '../send_invitation/invite_tenant_screen.dart';
import '../shared/setting_button.dart';
import 'company_user_cubit.dart';
import 'company_user_state.dart';

const companyUserPath = 'user_management';

class CompanyUserSreen extends StatefulWidget {
  const CompanyUserSreen({
    super.key,
    required this.companyId,
  });
  final String companyId;

  @override
  State<CompanyUserSreen> createState() => _CompanyUserSreenState();
}

class _CompanyUserSreenState extends State<CompanyUserSreen> {
  late final CompanyUserCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    await _cubit.init(
      companyId: widget.companyId,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyUserCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<CompanyUserCubit, CompanyUserState>(
          builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).user_management),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FullWidthTitle(
                    title: AppLocalizations.of(context).tenants,
                  ),
                  _createDataTable(state.userList ?? [], state.userListLimit),
                  SettingButton(
                    onPressed: () {
                      context.pushFromCurrentLocation(inviteTenantPath);
                    },
                    label: Text(
                      AppLocalizations.of(context).send_apartment_invitation,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  FullWidthTitle(
                    title: AppLocalizations.of(context).managers,
                    action: state.company?.isUserOwner == true
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return Dialog(
                                      child: ManagerCreationForm(
                                        onSubmit: (
                                            {required email,
                                            firstName,
                                            lastname,
                                            phone}) {
                                          _cubit
                                              .addNewManager(
                                                  email: email,
                                                  firstName: firstName,
                                                  lastName: lastname,
                                                  phone: phone)
                                              .then((value) =>
                                                  Navigator.pop(builder));
                                        },
                                      ),
                                    );
                                  });
                            },
                            child:
                                Text(AppLocalizations.of(context).add_manager))
                        : null,
                  ),
                  _createDataTable(
                      state.managerList ?? [], state.managerListLimit),
                ],
              ),
            ));
      }),
    );
  }

  PaginatedDataTable _createDataTable(List<User> userList, int? limit) {
    return PaginatedDataTable(
        rowsPerPage: limit ?? 5,
        columns: _createColumns(),
        source: CompanyUserDataTableSource(userList));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: FittedBox(child: Text(AppLocalizations.of(context).email))),
      DataColumn(
          label:
              FittedBox(child: Text(AppLocalizations.of(context).first_name))),
      DataColumn(
          label:
              FittedBox(child: Text(AppLocalizations.of(context).last_name))),
      DataColumn(
          label: FittedBox(
              child: Text(AppLocalizations.of(context).phone_number))),
      DataColumn(
          label:
              FittedBox(child: Text(AppLocalizations.of(context).apartment))),
    ];
  }
}

class CompanyUserDataTableSource extends DataTableSource {
  final List<User> userList;

  CompanyUserDataTableSource(this.userList);
  @override
  DataRow? getRow(int index) {
    final user = userList[index];
    return DataRow(cells: [
      DataCell(FittedBox(child: Text(user.email))),
      DataCell(FittedBox(child: Text(user.firstName))),
      DataCell(FittedBox(child: Text(user.lastName))),
      DataCell(Text(user.phone)),
      DataCell(FittedBox(
          child: Text(user.apartments?.isNotEmpty == true
              ? user.apartments!
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ". ")
              : '--'))),
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

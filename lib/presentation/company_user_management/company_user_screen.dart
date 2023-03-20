import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/company_user_management/manager_creation_form.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';

import '../../core/user/entities/user.dart';
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
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const FullWidthTitle(
                    title: 'Tenants',
                  ),
                  _createDataTable(state.userList ?? [], state.userListLimit),
                  FullWidthTitle(
                    title: 'Managers',
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
                            child: const Text('Add new manager'))
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
        source: UserDataTableSource(userList));
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: FittedBox(child: Text('Email'))),
      DataColumn(label: FittedBox(child: Text('First name'))),
      DataColumn(label: FittedBox(child: Text('Last name'))),
      DataColumn(label: FittedBox(child: Text('Phone number'))),
      DataColumn(label: FittedBox(child: Text('Apartment'))),
    ];
  }
}

class UserDataTableSource extends DataTableSource {
  final List<User> userList;

  UserDataTableSource(this.userList);
  @override
  DataRow? getRow(int index) {
    final user = userList[index];
    return DataRow(cells: [
      DataCell(FittedBox(child: Text(user.email))),
      DataCell(FittedBox(child: Text(user.firstName))),
      DataCell(FittedBox(child: Text(user.lastName))),
      DataCell(FittedBox(child: Text(user.phone))),
      DataCell(FittedBox(child: Text(user.apartments?.toString() ?? 'None'))),
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

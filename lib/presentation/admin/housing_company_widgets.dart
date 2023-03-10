import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'admin_cubit.dart';
import 'admin_state.dart';

class AdminCompanyListView extends StatelessWidget {
  const AdminCompanyListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
      return ListView.builder(
          itemCount: state.companyList?.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  GoRouter.of(context)
                      .push('/housing_company/${state.companyList![index].id}');
                },
                tileColor: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text('Company ${state.companyList![index].name}'),
              ),
            );
          });
    });
  }
}

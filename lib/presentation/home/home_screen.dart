import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_screen.dart';

import '../../service_locator.dart';
import '../code_register/code_register_screen.dart';
import 'home_cubit.dart';
import 'widgets/selectable_company_list.dart';

const homePath = '/';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit cubit;

  @override
  void initState() {
    cubit = serviceLocator<HomeCubit>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  _showMoreDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56)),
                        onPressed: () {
                          GoRouter.of(context).push(createCompanyPath);
                        },
                        child: const Text('Create a new company')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56)),
                        onPressed: () {
                          GoRouter.of(context).push(joinApartmentPath);
                        },
                        child: const Text('Join with Invitation Code')),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    cubit.getUserHousingCompanies();
    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: _showMoreDialog,
          child: const Icon(Icons.more_horiz_rounded),
        ),
        body: BlocProvider<HomeCubit>(
          create: (_) => cubit,
          child: const SelectableCompanyList(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/home/main_cubit.dart';
import 'package:priorli/presentation/home/widgets/selectable_company_list.dart';
import 'package:priorli/presentation/setting_screen.dart';
import 'package:priorli/service_locator.dart';

const mainPath = '/main';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cubit = serviceLocator<MainCubit>();

  @override
  Widget build(BuildContext context) {
    cubit.getUserHousingCompanies();
    return Scaffold(
        body: BlocProvider<MainCubit>(
      create: (_) => cubit,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SelectableCompanyList(),
          OutlinedButton(
            child: const Text('Setting'),
            onPressed: () {
              GoRouter.of(context).push(settingPath);
            },
          ),
          OutlinedButton(
            child: const Text('Create a housing company'),
            onPressed: () {
              GoRouter.of(context).push(
                createCompanyPath,
              );
            },
          ),
        ],
      ),
    ));
  }
}

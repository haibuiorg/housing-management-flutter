import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service_locator.dart';
import 'home_cubit.dart';
import 'widgets/selectable_company_list.dart';

const homePath = '/';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cubit = serviceLocator<HomeCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    cubit.getUserHousingCompanies();
    return Scaffold(
        body: BlocProvider<HomeCubit>(
      create: (_) => cubit,
      child: const SelectableCompanyList(),
    ));
  }
}

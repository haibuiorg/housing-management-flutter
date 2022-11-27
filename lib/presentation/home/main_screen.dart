import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/home/main_cubit.dart';
import 'package:priorli/presentation/home/widgets/selectable_company_list.dart';
import 'package:priorli/presentation/setting_screen.dart';
import 'package:priorli/service_locator.dart';

import '../notification_center/notification_center_screen.dart';

const mainPath = '/main';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cubit = serviceLocator<MainCubit>();

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  _checkNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: const Text(
                      'Do you want to receive notification when there are new important announcements or when something require your action?'),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                          Navigator.pop(context, true);
                        },
                        child: const Text('That\'s ok'))
                  ],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    cubit.getUserHousingCompanies();
    return Scaffold(
        body: BlocProvider<MainCubit>(
      create: (_) => cubit,
      child: Stack(
        children: [
          const Expanded(child: SelectableCompanyList()),
          OutlinedButton(
            child: const Text('Messages'),
            onPressed: () {
              GoRouter.of(context).push(
                notificationCenterPath,
              );
            },
          ),
          OutlinedButton(
            child: const Text('Setting'),
            onPressed: () {
              GoRouter.of(context).push(settingPath);
            },
          ),
          OutlinedButton(
            child: const Text('Create a housing comumnity'),
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

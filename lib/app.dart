import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/app_state.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/presentation/login_screen.dart';
import 'package:priorli/presentation/main_screen.dart';

import 'auth_cubit.dart';
import 'go_router_navigation.dart';
import 'service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(
            create: (context) => serviceLocator<SettingCubit>()),
        BlocProvider<AuthCubit>(
            create: (context) => serviceLocator<AuthCubit>()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (!state.isLoggedIn) {
          appRouter.go(loginPath);
        } else {
          appRouter.go(mainPath);
        }
      }, builder: (context, state) {
        return BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            theme: state.brightness == Brightness.dark
                ? ThemeData.dark(useMaterial3: true)
                : ThemeData.light(useMaterial3: false),
          );
        });
      }),
    );
  }
}

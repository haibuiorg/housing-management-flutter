import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'auth_cubit.dart';
import 'go_router_navigation.dart';
import 'service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.amber);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.amber, brightness: Brightness.dark);

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
          return DynamicColorBuilder(
              builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              theme: ThemeData(
                colorScheme: lightColorScheme ?? _defaultLightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
                useMaterial3: true,
              ),
              themeMode: state.brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
            );
          });
        });
      }),
    );
  }
}

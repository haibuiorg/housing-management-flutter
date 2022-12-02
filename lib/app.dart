import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'auth_cubit.dart';
import 'core/utils/color_extension.dart';
import 'go_router_navigation.dart';
import 'notification_controller.dart';
import 'service_locator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _defaultLightColorScheme(String? colorValue) => ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(colorValue ?? appSeedColor));

  _defaultDarkColorScheme(String? colorValue) => ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(colorValue ?? appSeedColor),
      brightness: Brightness.dark);

  @override
  void initState() {
    super.initState();
    _checkNotificationAction();
  }

  _checkNotificationAction() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod);
  }

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
                colorScheme: lightColorScheme ??
                    _defaultLightColorScheme(
                        state.ui?.seedColor ?? appSeedColor),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme ??
                    _defaultDarkColorScheme(
                        state.ui?.seedColor ?? appSeedColor),
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

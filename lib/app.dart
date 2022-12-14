import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/auth/usecases/is_logged_in.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/main.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_screen.dart';
import 'package:priorli/presentation/register/register_screen.dart';
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
  const App({super.key, this.initialLink});
  final PendingDynamicLinkData? initialLink;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _defaultLightColorScheme(String? colorValue) => ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(colorValue ?? appSeedColor));

  _defaultDarkColorScheme(String? colorValue) => ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(colorValue ?? appSeedColor),
      brightness: Brightness.dark);
  late final GoRouter appRouter;

  @override
  void initState() {
    super.initState();
    appRouter = serviceLocator<GoRouter>();
    _checkNotificationAction();
    _checkForInitialLink();
  }

  @override
  void dispose() {
    appRouter.dispose();
    super.dispose();
  }

  _checkNotificationAction() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod);
  }

  String? _getAppScreenPathFromAppLinkPath(String? appLinkPath) {
    try {
      List<String> linkData = appLinkPath?.split('/') ?? [];
      if (linkData.length < 3) {
        return mainPath;
      }
      final isLoggedIn =
          BlocProvider.of<AuthCubit>(context).state.isLoggedIn == true;
      if (isLoggedIn) {
        return '$joinApartmentPath/${linkData[1]}/${linkData[2]}';
      }
      return appLinkPath;
    } catch (error) {
      debugPrint(error.toString());
    }
    return mainPath;
  }

  _checkForInitialLink() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      GoRouter.of(context).push(
          _getAppScreenPathFromAppLinkPath(dynamicLinkData.link.path) ??
              mainPath);
    }).onError((error) {
      debugPrint(error);
    });
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
          if (widget.initialLink != null && widget.initialLink?.link != null) {
            appRouter.push(_getAppScreenPathFromAppLinkPath(
                    widget.initialLink?.link.path) ??
                registerPath);
          }
        } else {
          appRouter.go(mainPath);
          if (widget.initialLink != null && widget.initialLink?.link != null) {
            appRouter.push(_getAppScreenPathFromAppLinkPath(
                    widget.initialLink?.link.path) ??
                mainPath);
          }
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

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/presentation/code_register/code_register_screen.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_screen.dart';
import 'package:priorli/presentation/register/register_screen.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:priorli/user_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'auth_cubit.dart';
import 'core/utils/color_extension.dart';
import 'core/utils/os_utils.dart';
import 'notification_controller.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/shared/no_transition_builder.dart';
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
        BlocProvider<UserCubit>(
            create: (context) => serviceLocator<UserCubit>()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (!state.isLoggedIn) {
          if (appRouter.location == loginPath ||
              appRouter.location == registerPath ||
              appRouter.location == codeRegisterPath) {
            return;
          }
          appRouter.go(loginPath);
          if (widget.initialLink != null && widget.initialLink?.link != null) {
            appRouter.push(_getAppScreenPathFromAppLinkPath(
                    widget.initialLink?.link.path) ??
                registerPath);
          }
        } else {
          if (appRouter.location == loginPath ||
              appRouter.location == registerPath ||
              appRouter.location == codeRegisterPath) {
            appRouter.go(homePath);
          }
          if (widget.initialLink != null && widget.initialLink?.link != null) {
            appRouter.push(_getAppScreenPathFromAppLinkPath(
                    widget.initialLink?.link.path) ??
                homePath);
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
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: kIsWeb
                      ? {
                          // No animations for every OS if the app running on the web
                          for (final platform in TargetPlatform.values)
                            platform: const NoTransitionBuilder(),
                        }
                      : const {
                          TargetPlatform.android: ZoomPageTransitionsBuilder(),
                          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        },
                ),
                colorScheme: state.useSystemColor
                    ? lightColorScheme
                    : _defaultLightColorScheme(
                        state.ui?.seedColor ?? appSeedColor),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: kIsWeb
                      ? {
                          // No animations for every OS if the app running on the web
                          for (final platform in TargetPlatform.values)
                            platform: const NoTransitionBuilder(),
                        }
                      : const {
                          TargetPlatform.android: ZoomPageTransitionsBuilder(),
                          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                        },
                ),
                colorScheme: state.useSystemColor
                    ? lightColorScheme
                    : _defaultDarkColorScheme(
                        state.ui?.seedColor ?? appSeedColor),
                useMaterial3: true,
              ),
              themeMode: state.brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              builder: (context, child) => ResponsiveWrapper.builder(
                Column(
                  children: [
                    isIOSWeb
                        ? SizedBox(
                            height: 75,
                            child: Center(
                                child: Image.asset(
                                    'assets/app-store-png-logo.png')))
                        : isAndroidWeb
                            ? SizedBox(
                                height: 75,
                                child: Center(
                                  child: Image.asset(
                                      'assets/google-play-png-logo.png'),
                                ))
                            : const SizedBox.shrink(),
                    Expanded(
                        child: BouncingScrollWrapper.builder(context, child!)),
                  ],
                ),
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(480, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
                ],
              ),
            );
          });
        });
      }),
    );
  }
}

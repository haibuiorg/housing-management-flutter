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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'auth_cubit.dart';
import 'core/utils/color_extension.dart';
import 'core/utils/os_utils.dart';
import 'notification_controller.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/public/contact_us_public_screen.dart';
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
        seedColor: HexColor.fromHex(colorValue ?? appSeedColor),
        primary: HexColor.fromHex(appPrimaryColor),
        secondary: HexColor.fromHex(appSecondaryColor),
        background: HexColor.fromHex(appBackgroundColor),
        primaryContainer: HexColor.fromHex(appPrimaryContainerColor),
      );

  _defaultDarkColorScheme(String? colorValue) => ColorScheme.fromSeed(
      seedColor: HexColor.fromHex(colorValue ?? appSeedColorDark),
      primary: HexColor.fromHex(appPrimaryColorDark),
      secondary: HexColor.fromHex(appSecondaryColor),
      background: HexColor.fromHex(appBackgroundColorDark),
      primaryContainer: HexColor.fromHex(appPrimaryContainerColorDark),
      brightness: Brightness.dark);
  late final GoRouter appRouter;
  bool showDownloadDialog = isIOSWeb || isAndroidWeb;

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
      child: BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
        return DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) {
          return MaterialApp.router(
            locale: Locale(state.languageCode ?? 'fi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (context) {
              return 'Priorli dashboard';
            },
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor.fromHex(appPrimaryColor),
                    foregroundColor:
                        HexColor.fromHex(appPrimaryContainerColorDark)),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor:
                        HexColor.fromHex(appPrimaryContainerColorDark)),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        width: 1.0,
                        color: HexColor.fromHex(appPrimaryContainerColorDark)),
                    foregroundColor:
                        HexColor.fromHex(appPrimaryContainerColorDark)),
              ),
              fontFamily: 'Lato',
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
              fontFamily: 'Lato',
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        HexColor.fromHex(appPrimaryContainerColorDark),
                    foregroundColor: HexColor.fromHex(appPrimaryColor)),
              ),
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
              BouncingScrollWrapper.builder(
                context,
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                      final currentLocation = appRouter.location;
                      if (!state.isLoggedIn) {
                        if (currentLocation == loginPath ||
                            currentLocation == registerPath ||
                            currentLocation == contactUsPublicScreenRoute ||
                            currentLocation.contains(codeRegisterPath)) {
                          return;
                        }
                        appRouter.go(loginPath);
                        if (widget.initialLink != null &&
                            widget.initialLink?.link != null) {
                          appRouter.push(_getAppScreenPathFromAppLinkPath(
                                  widget.initialLink?.link.path) ??
                              registerPath);
                        }
                      } else {
                        if (currentLocation == loginPath ||
                            currentLocation == registerPath ||
                            currentLocation == codeRegisterPath) {
                          appRouter.go(homePath);
                        }
                        if (widget.initialLink != null &&
                            widget.initialLink?.link != null) {
                          appRouter.push(_getAppScreenPathFromAppLinkPath(
                                  widget.initialLink?.link.path) ??
                              homePath);
                        }
                      }
                    }, builder: (context, state) {
                      return child!;
                    }),
                    if (showDownloadDialog)
                      DownloadAppDialog(
                        onClosed: () {
                          setState(() {
                            showDownloadDialog = false;
                          });
                        },
                      ),
                  ],
                ),
              ),
              minWidth: 320,
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                ResponsiveBreakpoint.resize(800, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
              ],
            ),
          );
        });
      }),
    );
  }
}

class DownloadAppDialog extends StatelessWidget {
  const DownloadAppDialog(
      {super.key, this.networkImagePath, required this.onClosed});

  final String? networkImagePath;

  final Function() onClosed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClosed,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        onTap: () {},
        title: networkImagePath != null
            ? Image.network(networkImagePath!)
            : Image.asset(
                isIOSWeb
                    ? 'assets/app-store-png-logo.png'
                    : 'assets/google-play-png-logo.png',
                height: MediaQuery.of(context).size.height * 0.075,
              ),
        subtitle: const Text(
          'Get the full experience on your phone',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

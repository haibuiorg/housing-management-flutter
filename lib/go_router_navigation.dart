import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/login_screen.dart';
import 'package:priorli/presentation/main_screen.dart';
import 'package:priorli/presentation/setting_screen.dart';
import 'presentation/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: mainPath,
  routes: <GoRoute>[
    GoRoute(
      path: mainPath,
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: loginPath,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: registerPath,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: settingPath,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingScreen();
      },
    ),
  ],
  redirect: (context, state) async {
    return null;
  },
);

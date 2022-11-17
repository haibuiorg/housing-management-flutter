import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/setting_screen.dart';
import 'presentation/register/register_screen.dart';

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
      path: createCompanyPath,
      builder: (BuildContext context, GoRouterState state) {
        return const CreateHousingCompanyScreen();
      },
    ),
    GoRoute(
        path: '$housingCompanyScreenPath/:companyId',
        builder: (BuildContext context, GoRouterState state) {
          return HousingCompanyScreen(
            housingCompanyId: state.params['companyId'] ?? '',
          );
        },
        routes: [
          GoRoute(
            path: addApartmentPath,
            builder: (BuildContext context, GoRouterState state) {
              return const AddApartmentScreen();
            },
          ),
          GoRoute(
            path: inviteTenantPath,
            builder: (BuildContext context, GoRouterState state) {
              return const InviteTenantScreen();
            },
          ),
        ]),
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

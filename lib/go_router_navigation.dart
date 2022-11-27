import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/announcement/announcement_screen.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_screen.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';
import 'package:priorli/presentation/housing_company_management/housing_company_management_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/setting_screen.dart';
import 'package:priorli/presentation/water_consumption_management/water_consumption_management_screen.dart';
import 'presentation/apartment_invoice/apartment_water_invoice_screen.dart';
import 'presentation/apartments/apartment_screen.dart';
import 'presentation/housing_company_payment/housing_company_payment_screen.dart';
import 'presentation/register/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: mainPath,
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      redirect: (context, state) => mainPath,
    ),
    GoRoute(
      name: mainPath,
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
        name: housingCompanyScreenPath,
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
            path: announcementPath,
            builder: (BuildContext context, GoRouterState state) {
              return const AnnouncementScreen();
            },
          ),
          GoRoute(
              path: manageScreenPath,
              builder: (BuildContext context, GoRouterState state) {
                return const HousingCompanyManagementScreen();
              },
              routes: [
                GoRoute(
                  path: inviteTenantPath,
                  builder: (BuildContext context, GoRouterState state) {
                    return const InviteTenantScreen();
                  },
                ),
                GoRoute(
                  path: housingCompanyPaymentPath,
                  builder: (BuildContext context, GoRouterState state) {
                    return const HousingCompanyPaymentScreen();
                  },
                ),
              ]),
          GoRoute(
            path: waterConsumptionManagementScreenPath,
            builder: (BuildContext context, GoRouterState state) {
              return const WaterConsumptionManagementScreen();
            },
          ),
          GoRoute(
              path: '$apartmentScreenPath/:apartmentId',
              builder: (BuildContext context, GoRouterState state) {
                return ApartmentScreen(
                  apartmentId: state.params['apartmentId'] ?? '',
                );
              },
              routes: [
                GoRoute(
                  path: manageScreenPath,
                  builder: (BuildContext context, GoRouterState state) {
                    return const ApartmentManagementScreen();
                  },
                ),
                GoRoute(
                  path: apartmentWaterInvoice,
                  builder: (BuildContext context, GoRouterState state) {
                    return const ApartmentWaterInvoiceScreen();
                  },
                )
              ])
        ]),
    GoRoute(
      path: settingPath,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingScreen();
      },
    ),
    GoRoute(
      path: notificationCenterPath,
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationCenterScreen();
      },
    ),
  ],
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    return null;
  },
);

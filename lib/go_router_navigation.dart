import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/account/account_screen.dart';
import 'package:priorli/presentation/account/change_password_screen.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/announcement/announcement_screen.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_screen.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_screen.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/help/help_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';
import 'package:priorli/presentation/housing_company_management/housing_company_management_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import 'package:priorli/presentation/water_consumption_management/water_consumption_management_screen.dart';
import 'presentation/apartment_invoice/apartment_water_invoice_screen.dart';
import 'presentation/apartments/apartment_screen.dart';
import 'presentation/housing_company_payment/housing_company_payment_screen.dart';
import 'presentation/message/message_screen.dart';
import 'presentation/register/register_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: mainPath,
  routes: [
    GoRoute(
      path: mainPath,
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
        name: homePath,
        path: homePath,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: [
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
        ]),
    GoRoute(
      path: profilePath,
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
    GoRoute(
      path: conversationListPath,
      builder: (BuildContext context, GoRouterState state) {
        return const ConversationListScreen();
      },
    ),
    GoRoute(
      path: helpPath,
      builder: (BuildContext context, GoRouterState state) {
        return const HelpScreen();
      },
    ),
    GoRoute(
      path: '$messagePath/:messageType/:channelId/:conversationId',
      builder: (BuildContext context, GoRouterState state) {
        return MessageScreen(
          messageType: state.params['messageType'] ?? '',
          channelId: state.params['channelId'] ?? '',
          conversationId: state.params['conversationId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: loginPath,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: accountPath,
      builder: (BuildContext context, GoRouterState state) {
        return const AccountScreen();
      },
    ),
    GoRoute(
      path: changePasswordPath,
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
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
  ],
  debugLogDiagnostics: true,
);

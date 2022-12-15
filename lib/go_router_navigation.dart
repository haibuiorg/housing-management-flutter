import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/account/account_screen.dart';
import 'package:priorli/presentation/account/change_password_screen.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/announcement/announcement_screen.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_screen.dart';
import 'package:priorli/presentation/code_register/code_register_screen.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_screen.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/documents/document_list_screen.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_screen.dart';
import 'package:priorli/presentation/help/help_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';
import 'package:priorli/presentation/housing_company_management/housing_company_management_screen.dart';
import 'package:priorli/presentation/housing_company_ui/housing_company_ui_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import 'package:priorli/presentation/water_consumption_management/water_consumption_management_screen.dart';
import 'presentation/apartment_invoice/apartment_water_invoice_screen.dart';
import 'presentation/apartments/apartment_screen.dart';
import 'presentation/housing_company_payment/housing_company_payment_screen.dart';
import 'presentation/join_apartment/join_apartment_screen.dart';
import 'presentation/message/message_screen.dart';
import 'presentation/register/register_screen.dart';

const mainPathName = 'Main';
const homePathName = 'Home';
const housingCompanyScreenPathName = 'Housing company';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: mainPath,
    redirect: (context, state) {
      if (state.location == '/') {
        return mainPath;
      }
      return null;
    },
    routes: [
      GoRoute(
        name: mainPathName,
        path: mainPath,
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
      ),
      GoRoute(
          name: homePathName,
          path: homePath,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: [
            GoRoute(
                name: housingCompanyScreenPathName,
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
                        GoRoute(
                          path: housingCompanyUiScreenPath,
                          builder: (BuildContext context, GoRouterState state) {
                            return const HousingCompanyUiScreen();
                          },
                        ),
                      ]),
                  GoRoute(
                    path: documentListScreenPath,
                    builder: (BuildContext context, GoRouterState state) {
                      return const DocumentListScreen();
                    },
                  ),
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
                          path: documentListScreenPath,
                          builder: (BuildContext context, GoRouterState state) {
                            return const DocumentListScreen();
                          },
                        ),
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
      GoRoute(
        path: '$codeRegisterPath/:companyId/:code',
        builder: (BuildContext context, GoRouterState state) {
          return CodeRegisterScreen(
            code: state.params['code'],
            companyId: state.params['companyId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '$joinApartmentPath/:companyId/:code',
        builder: (BuildContext context, GoRouterState state) {
          return JoinApartmentScreen(
            code: state.params['code'],
            companyId: state.params['companyId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: joinApartmentPath,
        builder: (BuildContext context, GoRouterState state) {
          return const JoinApartmentScreen(
            code: '',
            companyId: '',
          );
        },
      ),
      GoRoute(
        path: codeRegisterPath,
        builder: (BuildContext context, GoRouterState state) {
          return const CodeRegisterScreen(
            code: '',
            companyId: '',
          );
        },
      ),
      GoRoute(
        path: forgotPasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordScreen();
        },
      ),
    ],
    debugLogDiagnostics: true,
  );
}

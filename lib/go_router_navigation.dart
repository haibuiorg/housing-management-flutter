import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/account/account_screen.dart';
import 'package:priorli/presentation/account/change_password_screen.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/admin/admin_screen.dart';
import 'package:priorli/presentation/announcement/announcement_screen.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_screen.dart';
import 'package:priorli/presentation/apartment_management_tenants/tenant_management_screen.dart';
import 'package:priorli/presentation/checkout/check_out_screen.dart';
import 'package:priorli/presentation/code_register/code_register_screen.dart';
import 'package:priorli/presentation/company_user_management/company_user_screen.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_screen.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_screen.dart';
import 'package:priorli/presentation/documents/document_list_screen.dart';
import 'package:priorli/presentation/events/event_screen.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_screen.dart';
import 'package:priorli/presentation/help/help_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_screen.dart';
import 'package:priorli/presentation/housing_company_management/housing_company_management_screen.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_screen.dart';
import 'package:priorli/presentation/housing_company_ui/housing_company_ui_screen.dart';
import 'package:priorli/presentation/invoice/invoice_creation_form.dart';
import 'package:priorli/presentation/invoice/invoice_group_list_screen.dart';
import 'package:priorli/presentation/invoice/invoice_list_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_screen.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/polls/poll_screen.dart';
import 'package:priorli/presentation/public/contact_us_public_screen.dart';
import 'package:priorli/presentation/public/chat_public_screen.dart';
import 'package:priorli/presentation/public/onboarding_screen.dart';
import 'package:priorli/presentation/send_invitation/invite_tenant_screen.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import 'package:priorli/presentation/water_consumption_management/water_consumption_management_screen.dart';
import 'presentation/apartment_invoice/apartment_water_invoice_screen.dart';
import 'presentation/apartments/apartment_screen.dart';
import 'presentation/housing_company_payment/housing_company_payment_screen.dart';
import 'presentation/join_apartment/join_apartment_screen.dart';
import 'presentation/message/message_screen.dart';
import 'presentation/payment_success/payment_success_screen.dart';
import 'presentation/public/register_screen.dart';
import 'presentation/shared/dialog_page.dart';

const homePathName = 'Home';
const housingCompanyScreenPathName = 'Housing company';
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: homePath,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
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
                        return AddApartmentScreen(
                          housingCompanyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                      path: announcementPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return AnnouncementScreen(
                          housingCompanyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                      path: ':isPersonal/$invoiceListPath/:groupId',
                      builder: (BuildContext context, GoRouterState state) {
                        return InvoiceListScreen(
                          companyId: state.params['companyId'] ?? '',
                          invoiceGroupId: state.params['groupId'] ?? '',
                          isPersonal: state.params['isPersonal'] == 'personal',
                        );
                      },
                    ),
                    GoRoute(
                      path: invoiceCreationPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return InvoiceCreationForm(
                          companyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                      path: invoiceGroupPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return InvoiceGroupListScreen(
                          companyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                        path: manageScreenPath,
                        builder: (BuildContext context, GoRouterState state) {
                          return HousingCompanyManagementScreen(
                            companyId: state.params['companyId'] ?? '',
                          );
                        },
                        routes: [
                          GoRoute(
                              path: companyUserPath,
                              builder:
                                  (BuildContext context, GoRouterState state) {
                                return CompanyUserSreen(
                                  companyId: state.params['companyId'] ?? '',
                                );
                              },
                              routes: [
                                GoRoute(
                                  path: inviteTenantPath,
                                  builder: (BuildContext context,
                                      GoRouterState state) {
                                    return InviteTenantScreen(
                                      housingCompanyId:
                                          state.params['companyId'] ?? '',
                                    );
                                  },
                                ),
                              ]),
                          GoRoute(
                            path: companySubscriptionScreenPath,
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return CompanySubscriptionScreen(
                                companyId: state.params['companyId'] ?? '',
                              );
                            },
                          ),
                          GoRoute(
                            path: housingCompanyPaymentPath,
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return HousingCompanyPaymentScreen(
                                companyId: state.params['companyId'] ?? '',
                              );
                            },
                          ),
                          GoRoute(
                            path: housingCompanyUiScreenPath,
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return HousingCompanyUiScreen(
                                housingCompanyId:
                                    state.params['companyId'] ?? '',
                              );
                            },
                          ),
                        ]),
                    GoRoute(
                      path: documentListScreenPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return DocumentListScreen(
                          companyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                      path: '$eventScreenPath/:eventId',
                      builder: (BuildContext context, GoRouterState state) {
                        return EventScreen(
                          companyId: state.params['companyId'] ?? '',
                          eventId: state.params['eventId'],
                          initialStartTime:
                              state.queryParams['initialStartTime'],
                          initialEndTime: state.queryParams['initialEndTime'],
                        );
                      },
                    ),
                    GoRoute(
                      path: eventScreenPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return EventScreen(
                          companyId: state.params['companyId'] ?? '',
                          initialStartTime:
                              state.queryParams['initialStartTime'],
                          initialEndTime: state.queryParams['initialEndTime'],
                        );
                      },
                    ),
                    GoRoute(
                      path: pollScreenPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return PollScreen(
                          companyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                      path: '$pollScreenPath/:pollId',
                      builder: (BuildContext context, GoRouterState state) {
                        return PollScreen(
                          companyId: state.params['companyId'] ?? '',
                          pollId: state.params['pollId'],
                        );
                      },
                    ),
                    GoRoute(
                      path: waterConsumptionManagementScreenPath,
                      builder: (BuildContext context, GoRouterState state) {
                        return WaterConsumptionManagementScreen(
                          housingCompanyId: state.params['companyId'] ?? '',
                        );
                      },
                    ),
                    GoRoute(
                        path: '$apartmentScreenPath/:apartmentId',
                        builder: (BuildContext context, GoRouterState state) {
                          return ApartmentScreen(
                            companyId: state.params['companyId'] ?? '',
                            apartmentId: state.params['apartmentId'] ?? '',
                          );
                        },
                        routes: [
                          GoRoute(
                              path: manageScreenPath,
                              builder:
                                  (BuildContext context, GoRouterState state) {
                                return ApartmentManagementScreen(
                                  companyId: state.params['companyId'] ?? '',
                                  apartmentId:
                                      state.params['apartmentId'] ?? '',
                                );
                              },
                              routes: [
                                GoRoute(
                                  path: tenantManagementPath,
                                  builder: (context, state) {
                                    return TenantManagementScreen(
                                      companyId:
                                          state.params['companyId'] ?? '',
                                      apartmentId:
                                          state.params['apartmentId'] ?? '',
                                    );
                                  },
                                ),
                                GoRoute(
                                  path: apartmentWaterInvoice,
                                  builder: (BuildContext context,
                                      GoRouterState state) {
                                    return ApartmentWaterInvoiceScreen(
                                      companyId:
                                          state.params['companyId'] ?? '',
                                      apartmentId:
                                          state.params['apartmentId'] ?? '',
                                    );
                                  },
                                ),
                                GoRoute(
                                  path: documentListScreenPath,
                                  builder: (BuildContext context,
                                      GoRouterState state) {
                                    return DocumentListScreen(
                                      companyId:
                                          state.params['companyId'] ?? '',
                                      apartmentId:
                                          state.params['apartmentId'] ?? '',
                                    );
                                  },
                                ),
                              ]),
                        ])
                  ]),
            ],
          ),
          GoRoute(
            path: profilePath,
            builder: (BuildContext context, GoRouterState state) {
              return const SettingScreen();
            },
          ),
          GoRoute(
            path: conversationListPath,
            builder: (BuildContext context, GoRouterState state) {
              return const ConversationListScreen();
            },
          ),
          GoRoute(
            path: adminScreenPath,
            builder: (BuildContext context, GoRouterState state) {
              return const AdminScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/$checkoutScreenPath/:sessionId',
        builder: (BuildContext context, GoRouterState state) {
          return CheckoutScreen(
            sessionId: state.params['sessionId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/$paymentSuccessPath',
        builder: (BuildContext context, GoRouterState state) {
          return PaymentSuccessScreen(
            sessionId: state.queryParams['session_id'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/$eventScreenPath/:eventId',
        builder: (BuildContext context, GoRouterState state) {
          return EventScreen(
            companyId: state.params['companyId'] ?? '',
            eventId: state.params['eventId'],
            initialStartTime: state.queryParams['initialStartTime'],
            initialEndTime: state.queryParams['initialEndTime'],
          );
        },
      ),
      GoRoute(
        path: notificationCenterPath,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationCenterScreen();
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
        pageBuilder: (context, state) => DialogPage(
          child: const AccountScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: changePasswordPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: onboardingScreenPath,
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen(
            isSignUpFlow: true,
          );
        },
      ),
      GoRoute(
        path: contactUsPublicScreenRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const ContactUsPublicScreen();
        },
      ),
      GoRoute(
        path: publicChatScreenPath,
        builder: (BuildContext context, GoRouterState state) {
          return const ChatPublicScreen();
        },
      ),
      GoRoute(
        path: createCompanyPath,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateHousingCompanyScreen();
        },
      ),
      GoRoute(
        path: codeRegisterPath,
        builder: (BuildContext context, GoRouterState state) {
          return CodeRegisterScreen(
            code: state.queryParams['code'],
            email: state.params['email'] ?? '',
          );
        },
      ),
      GoRoute(
        path: joinApartmentPath,
        builder: (BuildContext context, GoRouterState state) {
          return const JoinApartmentScreen(
            code: '',
          );
        },
      ),
      GoRoute(
        path: codeRegisterPath,
        builder: (BuildContext context, GoRouterState state) {
          return const CodeRegisterScreen(
            code: '',
            email: '',
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

extension AppGoRouterHelper on BuildContext {
  /// Push a location onto the page stack.

  void pushFromCurrentLocation(String location, {Object? extra}) {
    final newLocation =
        '${GoRouter.of(this).location}/$location'.replaceAll('//', '/');
    GoRouter.of(this).push(newLocation, extra: extra);
  }
}

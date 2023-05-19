import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/announcement/data/announcement_data_source.dart';
import 'package:priorli/core/announcement/data/announcement_remote_data_source.dart';
import 'package:priorli/core/announcement/repos/announcement_repository.dart';
import 'package:priorli/core/announcement/repos/announcement_repository_impl.dart';
import 'package:priorli/core/announcement/usecases/edit_announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/announcement/usecases/make_annoucement.dart';
import 'package:priorli/core/apartment/usecases/add_apartment_documents.dart';
import 'package:priorli/core/apartment/usecases/cancel_apartment_invitations.dart';
import 'package:priorli/core/apartment/usecases/delete_apartment.dart';
import 'package:priorli/core/apartment/usecases/edit_apartment_owner.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document_list.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_tenants.dart';
import 'package:priorli/core/apartment/usecases/get_pending_apartment_invitation.dart';
import 'package:priorli/core/apartment/usecases/join_apartment.dart';
import 'package:priorli/core/apartment/usecases/remove_tenant_from_apartment.dart';
import 'package:priorli/core/apartment/usecases/resend_apartment_invitation.dart';
import 'package:priorli/core/auth/usecases/login_with_token.dart';
import 'package:priorli/core/chatbot/add_document_index.dart';
import 'package:priorli/core/chatbot/add_generic_reference_doc.dart';
import 'package:priorli/core/chatbot/chatbot_data_source.dart';
import 'package:priorli/core/chatbot/chatbot_remote_data_source.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';
import 'package:priorli/core/chatbot/chatbot_repository_impl.dart';
import 'package:priorli/core/chatbot/get_document_indexes.dart';
import 'package:priorli/core/contact_leads/data/contact_lead_remote_data_source.dart';
import 'package:priorli/core/contact_leads/repos/contact_lead_repo.dart';
import 'package:priorli/core/contact_leads/repos/contact_lead_repo_impl.dart';
import 'package:priorli/core/contact_leads/usecases/get_contact_leads.dart';
import 'package:priorli/core/contact_leads/usecases/update_contact_lead.dart';
import 'package:priorli/core/country/data/country_data_source.dart';
import 'package:priorli/core/country/data/country_remote_data_source.dart';
import 'package:priorli/core/country/repos/country_repository.dart';
import 'package:priorli/core/country/repos/country_repository_impl.dart';
import 'package:priorli/core/country/usecases/get_country_data.dart';
import 'package:priorli/core/country/usecases/get_country_legal_documents.dart';
import 'package:priorli/core/country/usecases/get_support_countries.dart';
import 'package:priorli/core/event/data/event_data_source.dart';
import 'package:priorli/core/event/data/event_remote_data_source.dart';
import 'package:priorli/core/event/repos/event_repository.dart';
import 'package:priorli/core/event/repos/event_repository_impl.dart';
import 'package:priorli/core/event/usecases/create_event.dart';
import 'package:priorli/core/event/usecases/edit_event.dart';
import 'package:priorli/core/event/usecases/get_event.dart';
import 'package:priorli/core/event/usecases/get_event_list.dart';
import 'package:priorli/core/event/usecases/invite_to_event.dart';
import 'package:priorli/core/event/usecases/remove_user_from_event.dart';
import 'package:priorli/core/event/usecases/response_to_event.dart';
import 'package:priorli/core/fault_report/data/fault_report_data_source.dart';
import 'package:priorli/core/fault_report/data/fault_report_remote_data_source.dart';
import 'package:priorli/core/fault_report/repos/fault_report_repository.dart';
import 'package:priorli/core/fault_report/repos/fault_report_repository_impl.dart';
import 'package:priorli/core/fault_report/usecases/create_fault_report.dart';
import 'package:priorli/core/housing/usecases/add_company_documents.dart';
import 'package:priorli/core/housing/usecases/add_company_manager.dart';
import 'package:priorli/core/housing/usecases/admin_get_companies.dart';
import 'package:priorli/core/housing/usecases/delete_housing_company.dart';
import 'package:priorli/core/housing/usecases/get_company_document.dart';
import 'package:priorli/core/housing/usecases/get_company_document_list.dart';
import 'package:priorli/core/housing/usecases/get_housing_company_managers.dart';
import 'package:priorli/core/housing/usecases/remove_housing_company_manager.dart';
import 'package:priorli/core/housing/usecases/remove_tenant_from_company.dart';
import 'package:priorli/core/housing/usecases/update_company_document.dart';
import 'package:priorli/core/invoice/data/invoice_data_source.dart';
import 'package:priorli/core/invoice/data/invoice_remote_data_source.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';
import 'package:priorli/core/invoice/repos/invoice_repository_impl.dart';
import 'package:priorli/core/invoice/usecases/create_new_invoices.dart';
import 'package:priorli/core/invoice/usecases/delete_invoice.dart';
import 'package:priorli/core/invoice/usecases/get_company_invoices.dart';
import 'package:priorli/core/invoice/usecases/get_company_payment_product_items.dart';
import 'package:priorli/core/invoice/usecases/get_invoice_detail.dart';
import 'package:priorli/core/invoice/usecases/get_personal_invoices.dart';
import 'package:priorli/core/invoice/usecases/remove_company_payment_product_item.dart';
import 'package:priorli/core/invoice/usecases/send_invoice_manually.dart';
import 'package:priorli/core/messaging/data/messaging_remote_data_source.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';
import 'package:priorli/core/messaging/repos/messaging_repository_impl.dart';
import 'package:priorli/core/messaging/usecases/get_community_messages.dart';
import 'package:priorli/core/messaging/usecases/get_company_conversation_lists.dart';
import 'package:priorli/core/messaging/usecases/get_conversation_detail.dart';
import 'package:priorli/core/messaging/usecases/get_conversation_lists.dart';
import 'package:priorli/core/messaging/usecases/get_support_messages.dart';
import 'package:priorli/core/messaging/usecases/join_conversation.dart';
import 'package:priorli/core/messaging/usecases/send_message.dart';
import 'package:priorli/core/messaging/usecases/set_conversation_seen.dart';
import 'package:priorli/core/messaging/usecases/start_conversation.dart';
import 'package:priorli/core/messaging/usecases/start_support_conversation.dart';
import 'package:priorli/core/notification/data/notification_message_data_source.dart';
import 'package:priorli/core/notification/data/notification_message_remote_data_source.dart';
import 'package:priorli/core/notification/repos/notification_message_repository.dart';
import 'package:priorli/core/notification/repos/notification_message_repository_impl.dart';
import 'package:priorli/core/notification/usescases/create_notification_channel.dart';
import 'package:priorli/core/notification/usescases/delete_notification_channel.dart';
import 'package:priorli/core/notification/usescases/get_notification_channels.dart';
import 'package:priorli/core/notification/usescases/get_notification_messages.dart';
import 'package:priorli/core/notification/usescases/set_notification_message_seen.dart';
import 'package:priorli/core/notification/usescases/subscribe_notification_channels.dart';
import 'package:priorli/core/payment/data/payment_data_source.dart';
import 'package:priorli/core/payment/data/payment_remote_data_source.dart';
import 'package:priorli/core/payment/repos/payment_repository.dart';
import 'package:priorli/core/payment/repos/payment_repository_impl.dart';
import 'package:priorli/core/payment/usecases/get_all_bank_accounts.dart';
import 'package:priorli/core/payment/usecases/remove_bank_account.dart';
import 'package:priorli/core/poll/data/poll_data_source.dart';
import 'package:priorli/core/poll/data/poll_remote_data_source.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';
import 'package:priorli/core/poll/repos/poll_repository_impl.dart';
import 'package:priorli/core/poll/usecases/add_poll_option.dart';
import 'package:priorli/core/poll/usecases/create_poll.dart';
import 'package:priorli/core/poll/usecases/edit_poll.dart';
import 'package:priorli/core/poll/usecases/get_poll.dart';
import 'package:priorli/core/poll/usecases/get_poll_list.dart';
import 'package:priorli/core/poll/usecases/invite_users_to_poll.dart';
import 'package:priorli/core/poll/usecases/remove_poll_option.dart';
import 'package:priorli/core/poll/usecases/select_poll_option.dart';
import 'package:priorli/core/storage/data/storage_data_source.dart';
import 'package:priorli/core/storage/data/storage_remote_data_source.dart';
import 'package:priorli/core/storage/repos/storage_repository.dart';
import 'package:priorli/core/storage/repos/storage_repository_impl.dart';
import 'package:priorli/core/storage/usecases/upload_file.dart';
import 'package:priorli/core/subscription/data/subscription_data_source.dart';
import 'package:priorli/core/subscription/data/subscription_remote_data_source.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';
import 'package:priorli/core/subscription/repos/subscription_repository_impl.dart';
import 'package:priorli/core/subscription/usecases/add_payment_product.dart';
import 'package:priorli/core/subscription/usecases/add_subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/check_out.dart';
import 'package:priorli/core/subscription/usecases/delete_subscription_plan.dart';
import 'package:priorli/core/subscription/usecases/get_available_subscription_plans.dart';
import 'package:priorli/core/subscription/usecases/get_payment_key.dart';
import 'package:priorli/core/subscription/usecases/get_payment_products.dart';
import 'package:priorli/core/subscription/usecases/get_subscriptions.dart';
import 'package:priorli/core/subscription/usecases/remove_payment_product.dart';
import 'package:priorli/core/subscription/usecases/subscription_status_check.dart';
import 'package:priorli/core/user/usecases/register_with_code.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_link.dart';
import 'package:priorli/core/water_usage/usecases/get_yearly_water_consumption.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/account/account_cubit.dart';
import 'package:priorli/presentation/add_apartment/add_apart_cubit.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';
import 'package:priorli/presentation/announcement/announcement_cubit.dart';
import 'package:priorli/presentation/announcement/announcement_item_cubit.dart';
import 'package:priorli/presentation/apartment_invoice/apartment_water_invoice_cubit.dart';
import 'package:priorli/presentation/apartment_management_tenants/tenant_management_cubit.dart';
import 'package:priorli/presentation/apartments/apartment_cubit.dart';
import 'package:priorli/presentation/checkout/check_out_cubit.dart';
import 'package:priorli/presentation/code_register/code_register_cubit.dart';
import 'package:priorli/presentation/company_user_management/company_user_cubit.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_cubit.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_cubit.dart';
import 'package:priorli/presentation/documents/document_list_screen_cubit.dart';
import 'package:priorli/presentation/events/event_screen_cubit.dart';
import 'package:priorli/presentation/file_selector/file_selector_cubit.dart';
import 'package:priorli/presentation/forgot_password/forgot_password_cubit.dart';
import 'package:priorli/presentation/help/help_cubit.dart';
import 'package:priorli/presentation/home/home_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_cubit.dart';
import 'package:priorli/presentation/guest_invitation/guest_invitation_cubit.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_creation_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_group_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_list_cubit.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_cubit.dart';
import 'package:priorli/presentation/main/main_cubit.dart';
import 'package:priorli/presentation/message/message_cubit.dart';
import 'package:priorli/presentation/notification_center/notification_center_cubit.dart';
import 'package:priorli/presentation/payment_success/payment_success_cubit.dart';
import 'package:priorli/presentation/polls/poll_screen_cubit.dart';
import 'package:priorli/presentation/public/chat_public_cubit.dart';
import 'package:priorli/presentation/public/contact_us_public_cubit.dart';
import 'package:priorli/user_cubit.dart';

import 'auth_cubit.dart';
import 'core/apartment/data/apartment_data_source.dart';
import 'core/apartment/data/apartment_remote_data_source.dart';
import 'core/apartment/repos/apartment_repository.dart';
import 'core/apartment/repos/apartment_repository_impl.dart';
import 'core/apartment/usecases/add_apartments.dart';
import 'core/apartment/usecases/edit_apartment.dart';
import 'core/apartment/usecases/get_apartment.dart';
import 'core/apartment/usecases/get_apartments.dart';
import 'core/apartment/usecases/send_invitation_to_apartment.dart';
import 'core/apartment/usecases/update_apartment_document.dart';
import 'core/auth/data/authentication_data_source.dart';
import 'core/auth/data/authentication_remote_data_source.dart';
import 'core/auth/repos/authentication_repository.dart';
import 'core/auth/repos/authentication_repository_impl.dart';
import 'core/auth/usecases/change_password.dart';
import 'core/auth/usecases/is_authenticated.dart';
import 'core/auth/usecases/is_email_verified.dart';
import 'core/auth/usecases/is_logged_in.dart';
import 'core/auth/usecases/log_out.dart';
import 'core/auth/usecases/login_email_password.dart';
import 'core/auth/usecases/reset_password.dart';
import 'core/chatbot/start_chatbot_conversation.dart';
import 'core/contact_leads/data/contact_lead_data_source.dart';
import 'core/contact_leads/usecases/submit_contact_form.dart';
import 'core/housing/data/housing_company_data_source.dart';
import 'core/housing/data/housing_company_remote_data_source.dart';
import 'core/housing/repos/housing_company_repository.dart';
import 'core/housing/repos/housing_company_repository_impl.dart';
import 'core/housing/usecases/create_housing_company.dart';
import 'core/housing/usecases/get_housing_companies.dart';
import 'core/housing/usecases/get_housing_company.dart';
import 'core/housing/usecases/get_housing_company_users.dart';
import 'core/housing/usecases/update_housing_company_info.dart';
import 'core/invoice/usecases/add_company_payment_product_item.dart';
import 'core/invoice/usecases/get_invoice_groups.dart';
import 'core/messaging/data/messaging_data_source.dart';
import 'core/payment/usecases/add_bank_account.dart';
import 'core/payment/usecases/setup_connect_payment_account.dart';
import 'core/settings/data/setting_data_source.dart';
import 'core/settings/data/setting_local_data_source.dart';
import 'core/settings/repo/setting_repository.dart';
import 'core/settings/repo/setting_repository_impl.dart';
import 'core/settings/usecases/get_setting.dart';
import 'core/settings/usecases/save_setting.dart';
import 'core/subscription/usecases/cancel_subscription.dart';
import 'core/subscription/usecases/purchase_payment_product.dart';
import 'core/user/data/user_data_source.dart';
import 'core/user/data/user_remote_data_source.dart';
import 'core/user/repos/user_repository.dart';
import 'core/user/repos/user_repository_impl.dart';
import 'core/user/usecases/create_user.dart';
import 'core/user/usecases/delete_user_notification_token.dart';
import 'core/user/usecases/get_user_info.dart';
import 'core/user/usecases/update_user_info.dart';
import 'core/user/usecases/update_user_notification_token.dart';
import 'core/water_usage/data/water_usage_data_source.dart';
import 'core/water_usage/data/water_usage_remote_data_source.dart';
import 'core/water_usage/repos/water_usage_repository.dart';
import 'core/water_usage/repos/water_usage_repository_impl.dart';
import 'core/water_usage/usecases/add_consumption_value.dart';
import 'core/water_usage/usecases/add_new_water_price.dart';
import 'core/water_usage/usecases/delete_water_price.dart';
import 'core/water_usage/usecases/get_active_water_price.dart';
import 'core/water_usage/usecases/get_latest_water_consumption.dart';
import 'core/water_usage/usecases/get_previous_water_consumption.dart';
import 'core/water_usage/usecases/get_water_bill.dart';
import 'core/water_usage/usecases/get_water_bill_by_year.dart';
import 'core/water_usage/usecases/get_water_consumption.dart';
import 'core/water_usage/usecases/get_water_price_history.dart';
import 'core/water_usage/usecases/start_new_water_consumptio_period.dart';
import 'presentation/apartment_management/apartment_management_cubit.dart';
import 'presentation/documents/document_screen_cubit.dart';
import 'presentation/housing_company_management/housing_company_management_cubit.dart';
import 'presentation/housing_company_ui/housing_company_ui_screen_cubit.dart';
import 'presentation/send_invitation/invite_tenant_cubit.dart';
import 'presentation/water_consumption_management/water_consumption_management_cubit.dart';
import 'setting_cubit.dart';
import 'core/base/network.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // App router
  serviceLocator.registerFactory<GoRouter>(() => createAppRouter());

  // Cubits
  serviceLocator.registerFactory(() => SettingCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));
  serviceLocator.registerFactory(() => MainCubit(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AuthCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => HomeCubit(serviceLocator()));
  serviceLocator.registerFactory(
      () => CreateHousingCompanyCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => HousingCompanyCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(
      () => AddApartmentCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() =>
      InviteTenantCubit(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => WaterConsumptionManagementCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => HousingCompanyManagementCubit(
      serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => ApartmentCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => ApartmentManagementCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => ApartmentWaterInvoiceCubit(
      serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => HousingCompanyPaymentCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator
      .registerFactory(() => NotificationCenterCubit(serviceLocator()));
  serviceLocator.registerFactory(() =>
      AnnouncementCubit(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => MessageCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(
      () => ConversationListCubit(serviceLocator(), serviceLocator()));
  serviceLocator
      .registerFactory(() => UserCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(
      () => AccountCubit(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => CodeRegisterCubit());
  serviceLocator.registerFactory(() => JoinApartmentCubit(serviceLocator()));
  serviceLocator.registerFactory(() => ForgotPasswordCubit(serviceLocator()));
  serviceLocator.registerFactory(
      () => FileSelectorCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => DocumentListScreenCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => DocumentScreenCubit());
  serviceLocator.registerFactory(() => AnnouncementItemCubit(serviceLocator()));
  serviceLocator.registerFactory(
      () => HousingCompanyUiScreenCubit(serviceLocator(), serviceLocator()));
  serviceLocator
      .registerFactory(() => HelpCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => EventScreenCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => PollScreenCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => GuestInvitationCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => InvoiceCreationCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => InvoiceListCubit(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(
      () => InvoiceGroupCubit(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => CompanyUserCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => CheckoutCubit(serviceLocator()));
  serviceLocator.registerFactory(() => AdminCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => CompanySubscriptionCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(() => PaymentSuccessCubit(serviceLocator()));
  serviceLocator.registerFactory(() => ContactUsPublicCubit(serviceLocator()));
  serviceLocator.registerFactory(() => TenantManagmentCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
  serviceLocator.registerFactory(
      () => ChatPublicCubit(serviceLocator(), serviceLocator()));

  /** usecases */

  // Announcement
  serviceLocator.registerLazySingleton<EditAnnouncement>(
      () => EditAnnouncement(announcementRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetAnnouncementList>(
      () => GetAnnouncementList(announcementRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetAnnouncement>(
      () => GetAnnouncement(announcementRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<MakeAnnouncement>(
      () => MakeAnnouncement(announcementRepository: serviceLocator()));

  // Notification messages
  serviceLocator.registerLazySingleton<CreateNotificationChannel>(() =>
      CreateNotificationChannel(
          notificationMessageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteNotificationChannel>(() =>
      DeleteNotificationChannel(
          notificationMessageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetNotificationChannel>(() =>
      GetNotificationChannel(notificationMessageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetNotificationMessages>(() =>
      GetNotificationMessages(notificationMessageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SetNotificationMessageSeen>(() =>
      SetNotificationMessageSeen(
          notificationMessageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SubscribeNotificationChannels>(() =>
      SubscribeNotificationChannels(
          notificationMessageRepository: serviceLocator()));

  // Auth
  serviceLocator.registerLazySingleton<IsAuthenticated>(
      () => IsAuthenticated(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<IsLoggedIn>(
      () => IsLoggedIn(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<IsEmailVerified>(
      () => IsEmailVerified(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LoginEmailPassword>(
      () => LoginEmailPassword(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LoginWithToken>(
      () => LoginWithToken(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LogOut>(
      () => LogOut(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ResetPassword>(
      () => ResetPassword(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ChangePassword>(
      () => ChangePassword(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteSubscriptionPlan>(
      () => DeleteSubscriptionPlan(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetSubscriptions>(
      () => GetSubscriptions(repository: serviceLocator()));

  // user
  serviceLocator.registerLazySingleton<RegisterWithCode>(
      () => RegisterWithCode(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<CreateUser>(
      () => CreateUser(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetUserInfo>(
      () => GetUserInfo(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateUserInfo>(
      () => UpdateUserInfo(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteUserNotificationToken>(
      () => DeleteUserNotificationToken(userRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateUserNotificationToken>(
      () => UpdateUserNotificationToken(userRepository: serviceLocator()));

  // setting

  serviceLocator.registerLazySingleton<GetSetting>(
      () => GetSetting(settingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SaveSetting>(
      () => SaveSetting(settingRepository: serviceLocator()));

  // housing company
  serviceLocator.registerLazySingleton<GetHousingCompanies>(
      () => GetHousingCompanies(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetHousingCompany>(
      () => GetHousingCompany(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<CreateHousingCompany>(
      () => CreateHousingCompany(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateHousingCompanyInfo>(() =>
      UpdateHousingCompanyInfo(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteHousingCompany>(
      () => DeleteHousingCompany(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetHousingCompanyUsers>(
      () => GetHousingCompanyUsers(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveHousingCompanyManager>(
      () => RemoveHousingCompanyManager(serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveTenantFromCompany>(
      () => RemoveTenantFromCompany(serviceLocator()));

  // payment
  serviceLocator.registerLazySingleton<AddBankAccount>(
      () => AddBankAccount(paymentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveBankAccount>(
      () => RemoveBankAccount(paymentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetAllBankAccounts>(
      () => GetAllBankAccounts(paymentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SetupConnectPaymentAccount>(
      () => SetupConnectPaymentAccount(paymentRepository: serviceLocator()));

  // apartment
  serviceLocator.registerLazySingleton<AddApartments>(
      () => AddApartments(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetApartments>(
      () => GetApartments(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetApartment>(
      () => GetApartment(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteApartment>(
      () => DeleteApartment(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<EditApartment>(
      () => EditApartment(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SendInvitationToApartment>(
      () => SendInvitationToApartment(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ResendApartmentInvitation>(
      () => ResendApartmentInvitation(serviceLocator()));
  serviceLocator.registerLazySingleton<CancelApartmentInvitation>(
      () => CancelApartmentInvitation(serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveTenantFromApartment>(
      () => RemoveTenantFromApartment(serviceLocator()));
  serviceLocator.registerLazySingleton<GetPendingApartmentInvitations>(
      () => GetPendingApartmentInvitations(serviceLocator()));
  serviceLocator.registerLazySingleton<GetApartmentTenants>(
      () => GetApartmentTenants(serviceLocator()));
  serviceLocator.registerLazySingleton<EditApartmentOwner>(
      () => EditApartmentOwner(serviceLocator()));
  serviceLocator.registerLazySingleton<JoinApartment>(
      () => JoinApartment(apartmentRepository: serviceLocator()));

  // water consumption
  serviceLocator.registerLazySingleton<AddConsumptionValue>(
      () => AddConsumptionValue(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<AddNewWaterPrice>(
      () => AddNewWaterPrice(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteWaterPrice>(
      () => DeleteWaterPrice(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetWaterPriceHistory>(
      () => GetWaterPriceHistory(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetActiveWaterPrice>(
      () => GetActiveWaterPrice(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetLatestWaterConsumption>(
      () => GetLatestWaterConsumption(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPreviousWaterConsumption>(() =>
      GetPreviousWaterConsumption(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetWaterBillByYear>(
      () => GetWaterBillByYear(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetWaterBill>(
      () => GetWaterBill(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetWaterConsumption>(
      () => GetWaterConsumption(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<StartNewWaterConsumptionPeriod>(() =>
      StartNewWaterConsumptionPeriod(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetYearlyWaterConsumption>(
      () => GetYearlyWaterConsumption(waterUsageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetWaterBillLink>(
      () => GetWaterBillLink(waterUsageRepository: serviceLocator()));

  // messages
  serviceLocator.registerLazySingleton<GetCommunityMessages>(
      () => GetCommunityMessages(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SendMessage>(
      () => SendMessage(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetSupportMessages>(
      () => GetSupportMessages(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetConversationList>(
      () => GetConversationList(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCompanyConversationList>(
      () => GetCompanyConversationList(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<StartConversation>(
      () => StartConversation(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<JoinConversation>(
      () => JoinConversation(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SetConversationSeen>(
      () => SetConversationSeen(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetConversationDetail>(
      () => GetConversationDetail(messagingRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UploadFile>(
      () => UploadFile(storageRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<StartSupportConversation>(
      () => StartSupportConversation(messagingRepository: serviceLocator()));

  // country
  serviceLocator.registerLazySingleton<GetSupportCountries>(
      () => GetSupportCountries(countryRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCountryData>(
      () => GetCountryData(countryRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCountryLegalDocuments>(
      () => GetCountryLegalDocuments(countryRepository: serviceLocator()));

  // documents
  serviceLocator.registerLazySingleton<AddApartmentDocuments>(
      () => AddApartmentDocuments(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetApartmentDocumentList>(
      () => GetApartmentDocumentList(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetApartmentDocument>(
      () => GetApartmentDocument(apartmentRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateApartmentDocument>(
      () => UpdateApartmentDocument(apartmentRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<AddCompanyDocuments>(
      () => AddCompanyDocuments(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCompanyDocumentList>(
      () => GetCompanyDocumentList(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCompanyDocument>(
      () => GetCompanyDocument(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateCompanyDocument>(
      () => UpdateCompanyDocument(housingCompanyRepository: serviceLocator()));

  // polls
  serviceLocator.registerLazySingleton<AddPollOption>(
      () => AddPollOption(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<CreatePoll>(
      () => CreatePoll(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<EditPoll>(
      () => EditPoll(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPollList>(
      () => GetPollList(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPoll>(
      () => GetPoll(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<InviteUsersToPoll>(
      () => InviteUsersToPoll(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemovePollOption>(
      () => RemovePollOption(pollRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SelectPollOption>(
      () => SelectPollOption(pollRepository: serviceLocator()));

  // events
  serviceLocator.registerLazySingleton<CreateEvent>(
      () => CreateEvent(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<EditEvent>(
      () => EditEvent(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetEventList>(
      () => GetEventList(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetEvent>(
      () => GetEvent(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<InviteToEvent>(
      () => InviteToEvent(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveUserFromEvent>(
      () => RemoveUserFromEvent(eventRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ResponseToEvent>(
      () => ResponseToEvent(eventRepository: serviceLocator()));

  // fault report
  serviceLocator.registerLazySingleton<CreateFaultReport>(
      () => CreateFaultReport(faultReportRepository: serviceLocator()));

  // invoice
  serviceLocator.registerLazySingleton<CreateNewInvoices>(
      () => CreateNewInvoices(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<DeleteInvoice>(
      () => DeleteInvoice(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCompanyInvoices>(
      () => GetCompanyInvoices(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPersonalInvoices>(
      () => GetPersonalInvoices(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetInvoiceDetail>(
      () => GetInvoiceDetail(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetInvoiceGroups>(
      () => GetInvoiceGroups(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SendInvoiceManually>(
      () => SendInvoiceManually(invoiceRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetCompanyPaymentProductItems>(
      () => GetCompanyPaymentProductItems(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveCompanyPaymentProductItem>(
      () => RemoveCompanyPaymentProductItem(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<AddCompanyPaymentProductItem>(
      () => AddCompanyPaymentProductItem(invoiceRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<AddCompanyManager>(
      () => AddCompanyManager(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetHousingCompanyManagers>(() =>
      GetHousingCompanyManagers(housingCompanyRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<AddSubscriptionPlan>(
      () => AddSubscriptionPlan(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetAvailableSubscriptionPlans>(() =>
      GetAvailableSubscriptionPlans(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<Checkout>(
      () => Checkout(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPaymentKey>(
      () => GetPaymentKey(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SubscriptionStatusCheck>(
      () => SubscriptionStatusCheck(subscriptionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<CancelSubscription>(
      () => CancelSubscription(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<PurchasePaymentProduct>(
      () => PurchasePaymentProduct(repository: serviceLocator()));

  serviceLocator.registerLazySingleton<GetContactLeads>(
      () => GetContactLeads(contactLeadRepo: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateContactLead>(
      () => UpdateContactLead(contactLeadRepo: serviceLocator()));
  serviceLocator.registerLazySingleton<AdminGetCompanies>(
      () => AdminGetCompanies(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<SubmitContactForm>(
      () => SubmitContactForm(contactLeadRepo: serviceLocator()));

  serviceLocator.registerLazySingleton<AddPaymentProduct>(
      () => AddPaymentProduct(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<RemovePaymentProduct>(
      () => RemovePaymentProduct(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetPaymentProducts>(
      () => GetPaymentProducts(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<AddGenericReferenceDoc>(
      () => AddGenericReferenceDoc(chatbotRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<AddDocumentIndex>(
      () => AddDocumentIndex(chatbotRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetDocumentIndexes>(
      () => GetDocumentIndexes(chatbotRepository: serviceLocator()));
  serviceLocator.registerFactory<StartChatbotConversation>(
      () => StartChatbotConversation(chatbotRepository: serviceLocator()));

  /** repos */
  serviceLocator.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(authenticationDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(settingRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<HousingCompanyRepository>(() =>
      HousingCompanyRepositoryImpl(housingCompanyDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<ApartmentRepository>(
      () => ApartmentRepositoryImpl(apartmentDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<WaterUsageRepository>(
      () => WaterUsageRepositoryImpl(waterUsageDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(paymentRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<AnnouncementRepository>(() =>
      AnnouncementRepositoryImpl(announcementDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<NotificationMessageRepository>(() =>
      NotificationMessageRepositoryImpl(
          notificationMessageDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<MessagingRepository>(
      () => MessagingRepositoryImpl(messagingDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<StorageRepository>(
      () => StorageRepositoryImpl(storageDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<CountryRepository>(
      () => CountryRepositoryImpl(countryDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(eventRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<PollRepository>(
      () => PollRepositoryImpl(pollRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<FaultReportRepository>(() =>
      FaultReportRepositoryImpl(faultReportRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<InvoiceRepository>(
      () => InvoiceRepositoryImpl(invoiceRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<SubscriptionRepository>(() =>
      SubscriptionRepositoryImpl(
          subscriptionRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<ContactLeadRepo>(
      () => ContactLeadRepoImpl(remoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<ChatbotRepository>(
      () => ChatbotRepositoryImpl(chatbotDataSource: serviceLocator()));

  /** datasource*/
  serviceLocator.registerLazySingleton<AuthenticationDataSource>(() =>
      AuthenticationRemoteDataSource(
          client: serviceLocator<Dio>(),
          firebaseAuth: serviceLocator<FirebaseAuth>()));
  serviceLocator.registerLazySingleton<UserDataSource>(
      () => UserRemoteDataSource(client: serviceLocator()));
  serviceLocator
      .registerLazySingleton<SettingDataSource>(() => SettingLocalDataSource());
  serviceLocator.registerLazySingleton<HousingCompanyDataSource>(
      () => HousingCompanyRemoteDataSource(serviceLocator<Dio>()));
  serviceLocator.registerLazySingleton<ApartmentDataSource>(
      () => ApartmentRemoteDataSource(serviceLocator<Dio>()));
  serviceLocator.registerLazySingleton<WaterUsageDataSource>(
      () => WaterUsageRemoteDataSource(client: serviceLocator<Dio>()));
  serviceLocator.registerLazySingleton<PaymentDataSource>(
      () => PaymentRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<AnnouncementDataSource>(
      () => AnnouncementRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<NotificationMessageDataSource>(
      () => NotificationMessageRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<MessagingDataSource>(() =>
      MessagingRemoteDataSource(
          firebaseStorage: serviceLocator(),
          firestore: serviceLocator(),
          client: serviceLocator()));
  serviceLocator.registerLazySingleton<StorageDataSource>(
      () => StorageRemoteDataSource(storage: serviceLocator()));
  serviceLocator.registerLazySingleton<CountryDataSource>(
      () => CountryRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<PollDataSource>(
      () => PollRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<EventDataSource>(
      () => EventRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<FaultReportDataSource>(
      () => FaultReportRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<InvoiceDataSource>(
      () => InvoiceRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<SubscriptionDataSource>(
      () => SubscriptionRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<ContactLeadDataSource>(
      () => ContactLeadRemoteDataSource(client: serviceLocator()));
  serviceLocator.registerLazySingleton<ChatbotDataSource>(
      () => ChatbotRemoteDataSource(client: serviceLocator()));

  /** network */
  serviceLocator.registerLazySingleton<Dio>(
      () => DioModule(firebaseAuth: serviceLocator()).dio);
  serviceLocator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  serviceLocator
      .registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  serviceLocator.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
}

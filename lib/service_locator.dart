import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:priorli/core/apartment/usecases/delete_apartment.dart';
import 'package:priorli/core/housing/usecases/delete_housing_company.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_link.dart';
import 'package:priorli/core/water_usage/usecases/get_yearly_water_consumption.dart';
import 'package:priorli/presentation/add_apartment/add_apart_cubit.dart';
import 'package:priorli/presentation/apartments/apartment_cubit.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_cubit.dart';
import 'package:priorli/presentation/home/main_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';

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
import 'core/housing/data/housing_company_data_source.dart';
import 'core/housing/data/housing_company_remote_data_source.dart';
import 'core/housing/repos/housing_company_repository.dart';
import 'core/housing/repos/housing_company_repository_impl.dart';
import 'core/housing/usecases/create_housing_company.dart';
import 'core/housing/usecases/get_housing_companies.dart';
import 'core/housing/usecases/get_housing_company.dart';
import 'core/housing/usecases/update_housing_company_info.dart';
import 'core/settings/data/setting_data_source.dart';
import 'core/settings/data/setting_local_data_source.dart';
import 'core/settings/repo/setting_repository.dart';
import 'core/settings/repo/setting_repository_impl.dart';
import 'core/settings/usecases/get_setting.dart';
import 'core/settings/usecases/save_setting.dart';
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
import 'presentation/housing_company_management/housing_company_management_cubit.dart';
import 'presentation/send_invitation/invite_tenant_cubit.dart';
import 'presentation/water_consumption_management/water_consumption_management_cubit.dart';
import 'setting_cubit.dart';
import 'core/base/network.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Cubits
  serviceLocator.registerFactory(() => SettingCubit(
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AuthCubit(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(
      () => MainCubit(serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator
      .registerFactory(() => CreateHousingCompanyCubit(serviceLocator()));
  serviceLocator.registerFactory(() => HousingCompanyCubit(
      serviceLocator(), serviceLocator(), serviceLocator()));
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
  serviceLocator.registerFactory(() => ApartmentCubit(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => ApartmentManagementCubit(
      serviceLocator(), serviceLocator(), serviceLocator()));
  /** usecases */
  // Auth
  serviceLocator.registerLazySingleton<IsAuthenticated>(
      () => IsAuthenticated(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<IsLoggedIn>(
      () => IsLoggedIn(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<IsEmailVerified>(
      () => IsEmailVerified(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LoginEmailPassword>(
      () => LoginEmailPassword(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<LogOut>(
      () => LogOut(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ResetPassword>(
      () => ResetPassword(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<ChangePassword>(
      () => ChangePassword(authenticationRepository: serviceLocator()));

  // user
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

  /** network */
  serviceLocator.registerLazySingleton<Dio>(
      () => DioModule(firebaseAuth: serviceLocator()).dio);
  serviceLocator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
}

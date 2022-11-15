import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:priorli/core/housing/data/housing_company_data_source.dart';
import 'package:priorli/core/housing/data/housing_company_remote_data_source.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/housing/repos/housing_company_repository_impl.dart';
import 'package:priorli/core/housing/usecases/create_housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_companies.dart';
import 'package:priorli/core/housing/usecases/update_housing_company_info.dart';

import 'auth_cubit.dart';
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
  serviceLocator.registerLazySingleton<CreateHousingCompany>(
      () => CreateHousingCompany(housingCompanyRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<UpdateHousingCompanyInfo>(() =>
      UpdateHousingCompanyInfo(housingCompanyRepository: serviceLocator()));

  /** repos */
  serviceLocator.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(authenticationDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(settingRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<HousingCompanyRepository>(() =>
      HousingCompanyRepositoryImpl(housingCompanyDataSource: serviceLocator()));

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

  /** network */
  serviceLocator.registerLazySingleton<Dio>(
      () => DioModule(firebaseAuth: serviceLocator()).dio);
  serviceLocator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
}

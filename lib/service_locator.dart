import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:priorli/auth_cubit.dart';

import 'setting_cubit.dart';
import 'core/base/auth/data/authentication_data_source.dart';
import 'core/base/auth/data/authentication_remote_data_source.dart';
import 'core/base/auth/repos/authentication_repository.dart';
import 'core/base/auth/repos/authentication_repository_impl.dart';
import 'core/base/auth/usecases/change_password.dart';
import 'core/base/auth/usecases/is_authenticated.dart';
import 'core/base/auth/usecases/is_logged_in.dart';
import 'core/base/auth/usecases/log_out.dart';
import 'core/base/auth/usecases/login_email_password.dart';
import 'core/base/auth/usecases/reset_password.dart';
import 'core/base/network.dart';
import 'core/base/settings/data/setting_data_source.dart';
import 'core/base/settings/data/setting_local_data_source.dart';
import 'core/base/settings/repo/setting_repository.dart';
import 'core/base/settings/repo/setting_repository_impl.dart';
import 'core/base/settings/usecases/get_setting.dart';
import 'core/base/settings/usecases/save_setting.dart';
import 'core/base/user/data/user_data_source.dart';
import 'core/base/user/data/user_remote_data_source.dart';
import 'core/base/user/repos/user_repository.dart';
import 'core/base/user/repos/user_repository_impl.dart';
import 'core/base/user/usecases/create_user.dart';
import 'core/base/user/usecases/delete_user_notification_token.dart';
import 'core/base/user/usecases/get_user_info.dart';
import 'core/base/user/usecases/update_user_info.dart';
import 'core/base/user/usecases/update_user_notification_token.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Cubits
  serviceLocator.registerFactory(() => SettingCubit(
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(
      () => AuthCubit(serviceLocator(), serviceLocator(), serviceLocator()));

  /** usecases */
  // Auth
  serviceLocator.registerLazySingleton<IsAuthenticated>(
      () => IsAuthenticated(authenticationRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<IsLoggedIn>(
      () => IsLoggedIn(authenticationRepository: serviceLocator()));
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

  /** repos */
  serviceLocator.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(authenticationDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(settingRemoteDataSource: serviceLocator()));

  /** datasource*/
  serviceLocator.registerLazySingleton<AuthenticationDataSource>(() =>
      AuthenticationRemoteDataSource(
          client: serviceLocator<Dio>(),
          firebaseAuth: serviceLocator<FirebaseAuth>()));
  serviceLocator.registerLazySingleton<UserDataSource>(
      () => UserRemoteDataSource(client: serviceLocator()));
  serviceLocator
      .registerLazySingleton<SettingDataSource>(() => SettingLocalDataSource());

  /** network */
  serviceLocator.registerLazySingleton<Dio>(
      () => DioModule(firebaseAuth: serviceLocator()).dio);
  serviceLocator.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
}

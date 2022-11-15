import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:priorli/core/base/exceptions.dart';
import '../models/user_model.dart';
import 'user_data_source.dart';

class UserRemoteDataSource implements UserDataSource {
  final Dio client;
  final String _path = '/user';
  final String _registerPath = '/register';

  UserRemoteDataSource({required this.client});

  @override
  Future<UserModel> getUserInfo() async {
    final response = await client.get(_path);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateUserInfo(
      {required String fistName,
      required String lastName,
      required String phone}) async {
    final body = {
      'first_name': fistName,
      'last_name': lastName,
      'phone': phone,
    };
    final response = await client.patch(_path, data: body);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateNotificationToken(
      {required String notificationToken}) async {
    final body = {'notification_tokens': notificationToken};
    debugPrint(body.toString());
    final response =
        await client.patch('$_path/notification_token', data: body);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<bool> deleteNotificationToken(
      {required String notificationToken}) async {
    final body = {'notification_tokens': notificationToken};
    debugPrint(body.toString());
    await client.delete('$_path/notification_token', data: body);
    return true;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String phone,
    required String firstName,
    required String lastName,
  }) async {
    final Map<String, dynamic> data = {
      "email": email,
      "password": password,
      "phone": phone,
      "first_name": firstName,
      "last_name": lastName
    };
    try {
      final result = await client.post(_registerPath, data: data);
      return UserModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException();
    }
  }
}

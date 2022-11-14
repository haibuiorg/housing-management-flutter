import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../exceptions.dart';
import 'authentication_data_source.dart';

class AuthenticationRemoteDataSource implements AuthenticationDataSource {
  final FirebaseAuth firebaseAuth;
  final Dio client;

  AuthenticationRemoteDataSource(
      {required this.client, required this.firebaseAuth});

  @override
  Future<bool> isAuthenticated() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser ??= await FirebaseAuth.instance.idTokenChanges().first;
    return firebaseUser != null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return !firebaseAuth.currentUser!.isAnonymous;
  }

  @override
  Future<bool> logOut() async {
    await firebaseAuth.signOut();
    return true;
  }

  @override
  Future<String?> getToken() async {
    final token = await firebaseAuth.currentUser?.getIdToken();
    return token;
  }

  @override
  Future<bool> loginWithEmailPassword(
      {required String email, required String password}) async {
    final userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCred.user != null;
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    final data = {
      "email": email,
    };
    try {
      final result = await client.post('/reset_password', data: data);
      return (result.data as Map<String, dynamic>)['result'] == 'success';
    } catch (error) {
      debugPrint(error.toString());
      debugPrint((error as DioError).response?.data?.toString());
      throw ServerException(
          serverMessage: ((error).response?.data as Map)['errors']?['message'],
          code: ((error).response?.data as Map)['errors']?['code'].toString());
    }
  }

  @override
  Future<bool> changePassword(
      {required String oldPassword, required String newPassword}) async {
    final data = {'old_password': oldPassword, 'new_password': newPassword};
    try {
      final tryLogin = await firebaseAuth.signInWithEmailAndPassword(
          email: firebaseAuth.currentUser?.email ?? '', password: oldPassword);
      if (tryLogin.user == null) {
        throw ServerException(
            serverMessage: 'Invalid password', code: 'wrong_password');
      } else {
        final result = await client.patch('/change_password', data: data);
        return (result.data as Map<String, dynamic>)['result'] == 'success';
      }
    } catch (error) {
      throw ServerException(
          serverMessage: 'Invalid password', code: 'wrong_password');
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    await firebaseAuth.currentUser?.reload();
    return firebaseAuth.currentUser?.emailVerified == true;
  }
}

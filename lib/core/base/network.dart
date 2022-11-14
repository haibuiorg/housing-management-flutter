import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DioModule {
  final FirebaseAuth firebaseAuth;

  DioModule({required this.firebaseAuth});

  Dio get dio {
    final newDio = Dio();
    newDio.options.baseUrl = "https://priorli.oa.r.appspot.com";
    newDio.options.connectTimeout = 60000; //60s
    newDio.options.receiveTimeout = 30000;
    newDio.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      var token = await firebaseAuth.currentUser?.getIdToken();
      if (token != null && token != '') {
        debugPrint(token);
        request.headers['Authorization'] = 'Bearer $token';
      } else if (!request.path.contains('/register') &&
          !request.path.contains('/code_register') &&
          !request.path.contains('/reset_password')) {
        return handler
            .reject(DioError(requestOptions: request, error: 'No auth token'));
      }
      return handler.next(request);
    }));
    return newDio;
  }
}

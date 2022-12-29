import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class DioModule {
  final FirebaseAuth firebaseAuth;

  DioModule({required this.firebaseAuth});

  Dio get dio {
    final newDio = Dio();
    newDio.options.baseUrl = Config.API_URL;
    newDio.options.connectTimeout = 60000; //60s
    newDio.options.receiveTimeout = 30000;
    newDio.interceptors.add(LogInterceptor(responseBody: true));
    newDio.interceptors
        .add(InterceptorsWrapper(onRequest: (request, handler) async {
      var token =
          await (await firebaseAuth.idTokenChanges().first)?.getIdToken();
      // ignore: unrelated_type_equality_checks
      if (token != null && token != '') {
        debugPrint(token);
        request.headers['Authorization'] = 'Bearer $token';
      } else if (!request.path.contains('/register') &&
          !request.path.contains('/code_register') &&
          !request.path.contains('/reset_password')) {
        return handler
            .resolve(Response(requestOptions: request, data: 'No auth token'));
      }
      return handler.next(request);
    }, onResponse: (response, handler) {
      debugPrint('${response.realUri}: ${response.data}');
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      debugPrint('${e.error}: ${e.message}');
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));
    return newDio;
  }
}

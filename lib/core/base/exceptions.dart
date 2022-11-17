import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ServerException extends Equatable implements Exception {
  final String? serverMessage;
  final String? code;
  final Object? error;

  ServerException({this.serverMessage, this.code, this.error}) {
    debugPrint('$serverMessage/$code/$error/');
  }
  @override
  List<Object?> get props => [serverMessage, code, error];
}

class CacheException implements Exception {}

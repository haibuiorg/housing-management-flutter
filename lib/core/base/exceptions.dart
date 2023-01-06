import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ServerException extends Equatable implements Exception {
  final String? serverMessage;
  final String? code;
  final dynamic error;

  ServerException({this.serverMessage, this.code, this.error}) {
    debugPrint('$serverMessage/$code/$error/');
    debugPrint((error as Error).stackTrace.toString());
  }
  @override
  List<Object?> get props => [serverMessage, code, error];
}

class CacheException implements Exception {}

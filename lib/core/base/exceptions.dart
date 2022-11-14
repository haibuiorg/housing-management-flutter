import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ServerException extends Equatable implements Exception{
  final String? serverMessage;
  final String? code;

  ServerException({this.serverMessage,this.code,}) {
    debugPrint(serverMessage);
  }
  @override
  List<Object?> get props => [serverMessage];
}

class CacheException implements Exception {}

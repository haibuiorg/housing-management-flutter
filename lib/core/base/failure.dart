import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class Failure extends Equatable {
}

class ServerFailure extends Failure {
  final String? serverMessage;
  final String? code;

  ServerFailure({this.serverMessage,this.code,}) {
    debugPrint('$serverMessage / $code');
  }
  @override
  List<Object?> get props => [serverMessage];
}
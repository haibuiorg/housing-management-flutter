import 'failure.dart';

abstract class Result<Type> {}

class ResultSuccess<Type> extends Result<Type> {
  final Type data;
  ResultSuccess(this.data);
}

class ResultFailure<Type> extends Result<Type> {
  final Failure failure;

  ResultFailure(this.failure);
}
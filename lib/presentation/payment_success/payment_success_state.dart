import 'package:equatable/equatable.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';

class PaymentSuccessState extends Equatable {
  final String? sessionId;
  final Subscription? subscription;

  const PaymentSuccessState({this.subscription, this.sessionId});

  PaymentSuccessState copyWith(
          {Subscription? subscription, String? sessionId}) =>
      PaymentSuccessState(
          subscription: subscription ?? this.subscription,
          sessionId: sessionId ?? this.sessionId);

  @override
  List<Object?> get props => [subscription, sessionId];
}

import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final String? paymentKey;
  final String? sessionId;

  const CheckoutState({this.paymentKey, this.sessionId});

  CheckoutState copyWith({String? paymentKey, String? sessionId}) =>
      CheckoutState(
          paymentKey: paymentKey ?? this.paymentKey,
          sessionId: sessionId ?? this.sessionId);

  @override
  List<Object?> get props => [paymentKey, sessionId];
}

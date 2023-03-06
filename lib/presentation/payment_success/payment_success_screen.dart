import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/payment_success/payment_success_cubit.dart';
import 'package:priorli/presentation/payment_success/payment_success_state.dart';
import 'package:priorli/service_locator.dart';

const paymentSuccessPath = 'payment_status';

class PaymentSuccessScreen extends StatefulWidget {
  final String sessionId;

  const PaymentSuccessScreen({super.key, required this.sessionId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late final PaymentSuccessCubit _cubit;

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<PaymentSuccessCubit>()..init(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentSuccessCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<PaymentSuccessCubit, PaymentSuccessState>(
          builder: (context, state) {
        return Scaffold(
          body: Center(
              child: Text(
                  state.subscription?.checkoutSessionId ?? 'Payment failed')),
        );
      }),
    );
  }
}

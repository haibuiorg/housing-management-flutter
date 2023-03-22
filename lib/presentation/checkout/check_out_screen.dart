import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/checkout/check_out_cubit.dart';
import 'package:priorli/presentation/checkout/check_out_state.dart';
import 'package:priorli/service_locator.dart';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

const checkoutScreenPath = 'checkout';

class CheckoutScreen extends StatefulWidget {
  final String sessionId;

  const CheckoutScreen({super.key, required this.sessionId});

  @override
  State<CheckoutScreen> createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  );
  late final CheckoutCubit _cubit;

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<CheckoutCubit>()
      ..init(widget.sessionId).then((value) => {
            _controller.loadRequest(
              LoadRequestParams(
                uri: Uri.parse(initialUrl),
              ),
            )
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider<CheckoutCubit>(
        create: (_) => _cubit,
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
          if (state.paymentKey != null) {
            _redirectToStripe(state.paymentKey!, state.sessionId!);
          }
        }, builder: (context, state) {
          return PlatformWebViewWidget(
            PlatformWebViewWidgetCreationParams(controller: _controller),
          ).build(context);
        }),
      ),
    );
  }

  void _redirectToStripe(String apiKey, String sessionId) {
    //<--- prepare the JS in a normal string
    final redirectToCheckoutJs = '''
var stripe = Stripe('$apiKey');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    _controller.runJavaScript(redirectToCheckoutJs);
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
Hello Webview
</body>
</html>
''';

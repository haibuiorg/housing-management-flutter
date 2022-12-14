import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLottieAnimation extends StatelessWidget {
  const AppLottieAnimation({Key? key, this.loadingResource}) : super(key: key);

  final String? loadingResource;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Center(
        child: SizedBox(
          width: constraints.maxWidth,
          child: Lottie.asset(
            loadingResource != null
                ? 'assets/$loadingResource.json'
                : 'assets/graphing.json',
          ),
        ),
      );
    });
  }
}

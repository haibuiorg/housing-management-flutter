
import 'package:flutter/material.dart';


class AppWebView extends StatefulWidget {
  const AppWebView({super.key, this.initialUrl});
  final String? initialUrl;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

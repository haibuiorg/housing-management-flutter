import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/utils/constants.dart';

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
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith(appWebsite)) {
          debugPrint('allowing navigation to $request');
          return NavigationDecision.navigate;
        }
        debugPrint('blocking navigation to $request}');
        return NavigationDecision.prevent;
      },
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: widget.initialUrl ?? appWebsite,
    );
  }
}

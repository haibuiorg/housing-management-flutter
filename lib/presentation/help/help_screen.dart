import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/app.dart';
import 'package:priorli/presentation/message/message_screen.dart';
import 'package:priorli/presentation/shared/app_webview.dart';
import 'package:url_launcher/url_launcher_string.dart';

const helpPath = '/faq';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  _launchPhone() {
    launchUrlString("tel://+358449230624");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Column(
        children: [
          const Expanded(child: AppWebView()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: _launchPhone,
                    icon: Icon(
                      Icons.call_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: call backend to create help channel
                    },
                    icon: Icon(
                      Icons.email_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

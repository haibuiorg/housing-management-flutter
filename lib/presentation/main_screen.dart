import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/setting_screen.dart';

const mainPath = '/main';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            child: const Text('Setting'),
            onPressed: () {
              GoRouter.of(context).push(settingPath);
            },
          ),
        ],
      ),
    );
  }
}

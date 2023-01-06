import 'package:flutter/material.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';

const adminScreenPath = '/admin';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('Admin'),
      ),
      body: const Center(
          child: AppLottieAnimation(
        loadingResource: 'graphing',
      )),
    );
  }
}

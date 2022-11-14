import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/presentation/register_screen.dart';

const loginPath = '/login';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  _login(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).logIn(email: '', password: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(),
            TextFormField(),
            OutlinedButton(
                onPressed: () => _login(context), child: const Text('Login')),
            OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).push(registerPath);
                },
                child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}

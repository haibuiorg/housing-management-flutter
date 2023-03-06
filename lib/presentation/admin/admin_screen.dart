import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';
import 'package:priorli/presentation/admin/admin_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';

const adminScreenPath = '/admin';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final AdminCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<AdminCubit>();
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('Admin'),
      ),
      body: BlocProvider<AdminCubit>(
        create: (context) => _cubit,
        child: BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
          return Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _cubit.addSubscription(
                        name: 'Starter',
                        price: 499,
                        currency: 'eur',
                        countryCode: 'fi');
                  },
                  child: const Text('Add subscription test')),
            ],
          );
        }),
      ),
    );
  }
}

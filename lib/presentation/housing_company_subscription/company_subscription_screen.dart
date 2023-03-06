import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_cubit.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_state.dart';
import 'package:priorli/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../checkout/check_out_screen.dart';

const companySubscriptionScreenPath = 'company_subscription';

class CompanySubscriptionScreen extends StatefulWidget {
  final String companyId;
  const CompanySubscriptionScreen({super.key, required this.companyId});

  @override
  State<CompanySubscriptionScreen> createState() =>
      _CompanySubscriptionScreenState();
}

class _CompanySubscriptionScreenState extends State<CompanySubscriptionScreen> {
  late final CompanySubscriptionCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<CompanySubscriptionCubit>()..init(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CompanySubscriptionCubit>(
        create: (_) => _cubit,
        child: BlocBuilder<CompanySubscriptionCubit, CompanySubscriptionState>(
            builder: (context, state) {
          return Center(
              child: ElevatedButton(
                  onPressed: () {
                    _cubit.checkoutSubscriptionPlan().then((value) => {
                          if (value?.isNotEmpty == true)
                            launchUrl(
                              Uri.parse(value!),
                            )
                        });
                  },
                  child: const Text('Test checkout')));
        }),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';
import 'package:priorli/presentation/admin/admin_state.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_screen.dart';
import 'package:priorli/service_locator.dart';

import 'housing_company_widgets.dart';
import 'sale_management_widgets.dart';
import 'subscription_management_widgets.dart';

const adminScreenPath = '/admin';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final AdminCubit _cubit;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<AdminCubit>()..getInit();
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCubit>(
      create: (context) => _cubit,
      child: BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
        return Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 20,
                shadowColor: Theme.of(context).colorScheme.primaryContainer,
                collapsedHeight: 120,
                title: const Text('Admin'),
                actions: [
                  DropdownButton<String>(
                    value: state.selectedCountryCode,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? value) {
                      _cubit.selectCountry(value);
                    },
                    items: state.supportedCountries
                        ?.map<DropdownMenuItem<String>>((Country value) {
                      return DropdownMenuItem<String>(
                        value: value.countryCode,
                        child: Text(value.countryCode),
                      );
                    }).toList(),
                  ),
                ],
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 54.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          onSelected: (value) {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          label: const Text('Sale management'),
                          selected: selectedIndex == 0,
                        ),
                        ChoiceChip(
                            onSelected: (value) {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            selected: selectedIndex == 1,
                            label: const Text('Housing company management')),
                        ChoiceChip(
                            onSelected: (value) {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            selected: selectedIndex == 2,
                            label:
                                const Text('Customer relationship management')),
                        ChoiceChip(
                            onSelected: (value) => setState(() {
                                  selectedIndex = 3;
                                }),
                            selected: selectedIndex == 3,
                            label: const Text('Subscription management')),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: selectedIndex == 0
              ? const ContactLeadListView()
              : selectedIndex == 1
                  ? const AdminCompanyListView()
                  : selectedIndex == 2
                      ? const ConversationListScreen(
                          isFromAdmin: true,
                        )
                      : const SubscriptionPlanListView(),
        ));
      }),
    );
  }
}

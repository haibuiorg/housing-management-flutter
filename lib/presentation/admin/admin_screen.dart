import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/app.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';
import 'package:priorli/presentation/admin/admin_state.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_screen.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final List<Widget> _widgetOptions = <Widget>[
    const ContactLeadListView(),
    const AdminCompanyListView(),
    const ConversationListScreen(),
    const SubscriptionPlanListView(),
  ];
  List<Tab> _tab(BuildContext context) => [
        Tab(
          child: Text(
            AppLocalizations.of(context).contact_lead,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Tab(
          child: Text(
            AppLocalizations.of(context).housing_companies,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Tab(
          child: Text(
            AppLocalizations.of(context).conversations,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Tab(
          child: Text(
            AppLocalizations.of(context).subscription_plans,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ];

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
        return DefaultTabController(
          length: _widgetOptions.length,
          child: Scaffold(
              body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  shadowColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(AppLocalizations.of(context)!.admin),
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
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(56.0),
                    child: TabBar(
                      tabs: _tab(context),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(children: _widgetOptions),
          )),
        );
      }),
    );
  }
}

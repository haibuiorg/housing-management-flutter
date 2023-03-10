import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_cubit.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_state.dart';
import 'package:priorli/presentation/shared/full_width_pair_text.dart';
import 'package:priorli/service_locator.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/constants.dart';

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
  late final TextEditingController _con = TextEditingController();
  bool yearly = true;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<CompanySubscriptionCubit>()..init(widget.companyId);
  }

  @override
  void dispose() {
    _cubit.close();
    _con.dispose();
    super.dispose();
  }

  subscribeToPlanByCard(SubscriptionPlan plan) async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Subscribe to ${plan.name}'),
            content: TextFormField(
              controller: _con,
              decoration: const InputDecoration(
                hintText: 'How many account do you want to create?',
                labelText: 'Quantity',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(builder),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    _cubit
                        .checkoutSubscriptionPlan(
                            quantity: int.tryParse(_con.text) ?? 1,
                            subscriptionPlanId: plan.id)
                        .then((value) => launchUrl(Uri.parse(value!)))
                        .then((value) => Navigator.pop(builder));
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  subscribeToPlanByInvoice(SubscriptionPlan plan) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CompanySubscriptionCubit>(
        create: (_) => _cubit,
        child: BlocBuilder<CompanySubscriptionCubit, CompanySubscriptionState>(
            builder: (context, state) {
          final List<SubscriptionPlan> plans = state.availableSubscriptionPlans
                  ?.where((element) => yearly
                      ? element.interval == 'year'
                      : element.interval == 'month')
                  .toList() ??
              [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        onSelected: (value) {
                          setState(() {
                            yearly = false;
                          });
                        },
                        label: const Text('Monthly price'),
                        selected: !yearly,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                          onSelected: (value) {
                            setState(() {
                              yearly = true;
                            });
                          },
                          selected: yearly,
                          label: const Text('Yearly price')),
                    ),
                  ],
                ),
              ),
              ResponsiveRowColumn(
                rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                children: plans
                    .map((e) => ResponsiveRowColumnItem(
                          child: SubscriptionPlanBox(
                              subscriptionPlan: e,
                              onPressed: () => subscribeToPlanByCard(e),
                              isCurrentPlan: state.companySubscriptionList
                                      ?.map((e) => e.subscriptionPlanId)
                                      .toList()
                                      .contains(e.id) ==
                                  true),
                        ))
                    .toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class SubscriptionPlanBox extends StatelessWidget {
  const SubscriptionPlanBox({
    super.key,
    required this.subscriptionPlan,
    required this.isCurrentPlan,
    required this.onPressed,
  });
  final SubscriptionPlan subscriptionPlan;
  final bool isCurrentPlan;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentPlan
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subscriptionPlan.name,
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            FullWidthPairText(
              label: 'Price: ',
              content: formatCurrency(
                  subscriptionPlan.price, subscriptionPlan.currency),
              isBoldContent: true,
            ),
            FullWidthPairText(
              label: 'Additional invoice cost: ',
              content: formatCurrency(subscriptionPlan.additionalInvoiceCost,
                  subscriptionPlan.currency),
              isBoldContent: true,
            ),
            FullWidthPairText(
                label: 'Max messaging channels: ',
                content: subscriptionPlan.maxMessagingChannels.toString()),
            FullWidthPairText(
                label: 'Max number of accounts: ',
                content: subscriptionPlan.maxAccount > maxNumeberOfAccount
                    ? 'Unlimited'
                    : subscriptionPlan.maxAccount.toString()),
            FullWidthPairText(
                label: 'Max invoice number:',
                content: subscriptionPlan.maxInvoiceNumber.toString()),
            FullWidthPairText(
                label: 'Max announcement number:',
                content: subscriptionPlan.maxAnnouncement.toString()),
            Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                    onPressed: onPressed,
                    child: Text(
                      isCurrentPlan ? 'Get more accounts' : 'Get it now',
                      maxLines: 1,
                    )))
          ],
        ),
      ),
    );
  }
}

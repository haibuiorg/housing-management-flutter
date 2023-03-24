import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/subscription/entities/subscription.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_cubit.dart';
import 'package:priorli/presentation/housing_company_subscription/company_subscription_state.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/subscription_plan_box.dart';

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
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
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
          final List<Subscription> companySubscriptions =
              state.companySubscriptionList ?? [];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FullWidthTitle(
                  title:
                      'Company credit: ${formatCurrency(state.company?.creditAmount, state.company?.currencyCode)}',
                ),
              ),
              SliverList.builder(
                  itemCount: state.paymentProducts?.length ?? 0,
                  itemBuilder: (context, index) {
                    final paymentProductItem = state.paymentProducts![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          _cubit
                              .purchasePaymentProduct(
                                  paymentProductId: paymentProductItem.id,
                                  quantity: 1)
                              .then((value) => launchUrl(Uri.parse(value!)));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        tileColor: Theme.of(context).cardColor,
                        title: Text(paymentProductItem.name),
                        subtitle: Text(formatCurrency(paymentProductItem.amount,
                            paymentProductItem.currencyCode)),
                      ),
                    );
                  }),
              const SliverToBoxAdapter(
                child: FullWidthTitle(
                  title: 'Current subscriptions',
                ),
              ),
              SliverGrid.builder(
                  gridDelegate: const ResponsiveGridDelegate(
                      maxCrossAxisExtent: 500,
                      childAspectRatio: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  itemCount: companySubscriptions.length,
                  itemBuilder: (itemBuilder, index) {
                    return SubscriptionBox(
                      subscription: companySubscriptions[index],
                    );
                  }),
              const SliverToBoxAdapter(
                child: FullWidthTitle(
                  title: 'Available subscriptions',
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              ),
              if (plans.isNotEmpty)
                SliverToBoxAdapter(
                  child: ResponsiveRowColumn(
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
                ),
            ],
          );
        }),
      ),
    );
  }
}

class SubscriptionBox extends StatelessWidget {
  const SubscriptionBox({
    super.key,
    required this.subscription,
  });

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanySubscriptionCubit, CompanySubscriptionState>(
        builder: (context, state) {
      final subscriptionPlans = state.availableSubscriptionPlans
              ?.where((p) => p.id == subscription.subscriptionPlanId)
              .toList() ??
          [];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.primaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          selected: !subscription.latestInvoicePaid,
          selectedColor: Theme.of(context).colorScheme.error,
          selectedTileColor: Theme.of(context).colorScheme.errorContainer,
          onTap: !subscription.latestInvoicePaid &&
                  subscription.latestInvoiceUrl.isNotEmpty
              ? () {
                  launchUrl(Uri.parse(subscription.latestInvoiceUrl));
                }
              : null,
          trailing: subscription.latestInvoicePaid
              ? null
              : const Icon(Icons.error_outline),
          title: Text(subscriptionPlans.isNotEmpty == true
              ? subscriptionPlans.first.name
              : 'Unknown plan'),
          subtitle: Text(
              'For ${subscription.quantity} apartments ${subscription.latestInvoicePaid ? '' : '\n(Invoice not paid - click to pay!)'}'),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';

import '../../../core/subscription/entities/subscription_plan.dart';
import '../../../core/utils/string_extension.dart';
import '../../shared/full_width_pair_text.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
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
                label: AppLocalizations.of(context)!.price_title,
                content: formatCurrency(
                    subscriptionPlan.price, subscriptionPlan.currency),
                isBoldContent: true,
              ),
              FullWidthPairText(
                label: AppLocalizations.of(context)!.cost_per_invoice(''),
                content: formatCurrency(subscriptionPlan.additionalInvoiceCost,
                    subscriptionPlan.currency),
                isBoldContent: true,
              ),
              FullWidthPairText(
                  label: AppLocalizations.of(context)!.max_messaging_channels,
                  content: subscriptionPlan.maxMessagingChannels.toString()),
              FullWidthPairText(
                  label: AppLocalizations.of(context)!.max_invoice_number,
                  content: subscriptionPlan.maxInvoiceNumber.toString()),
              FullWidthPairText(
                  label: AppLocalizations.of(context)!.max_announcements,
                  content: subscriptionPlan.maxAnnouncement.toString()),
              Align(
                  alignment: Alignment.center,
                  child: OutlinedButton(
                      onPressed: onPressed,
                      child: Text(
                        isCurrentPlan
                            ? AppLocalizations.of(context)!.get_more_apartments
                            : AppLocalizations.of(context)!.subscribe,
                        maxLines: 1,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

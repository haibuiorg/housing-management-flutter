import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/subscription/entities/subscription_plan.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/number_formatters.dart';
import '../../core/utils/string_extension.dart';
import 'admin_cubit.dart';
import 'admin_state.dart';

class SubscriptionPlanListView extends StatelessWidget {
  const SubscriptionPlanListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FullWidthTitle(
                  title: AppLocalizations.of(context).subscription_plans),
            ),
            SliverList.builder(
                itemCount: state.subscriptionPlanList?.length ?? 0,
                itemBuilder: (context, index) {
                  return SubscriptionTile(
                    subscriptionPlan: state.subscriptionPlanList![index],
                  );
                }),
            SliverToBoxAdapter(
              child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (builder) {
                          return SubscriptionPlanDialog(
                              currencyCode: state.supportedCountries
                                      ?.where((element) =>
                                          element.countryCode ==
                                          state.selectedCountryCode)
                                      .first
                                      .currencyCode ??
                                  'eur',
                              onSubmit: (
                                      {required additionalInvoiceCost,
                                      required hasApartmentDocument,
                                      interval,
                                      required intervalCount,
                                      required maxAnnouncement,
                                      required maxInvoiceNumber,
                                      required maxMessagingChannels,
                                      required name,
                                      required notificationTypes,
                                      required price,
                                      required translation}) =>
                                  BlocProvider.of<AdminCubit>(context)
                                      .addSubscription(
                                          additionalInvoiceCost:
                                              additionalInvoiceCost,
                                          hasApartmentDocument:
                                              hasApartmentDocument,
                                          interval: interval,
                                          intervalCount: intervalCount,
                                          maxAnnouncement: maxAnnouncement,
                                          maxInvoiceNumber: maxInvoiceNumber,
                                          maxMessagingChannels:
                                              maxMessagingChannels,
                                          name: name,
                                          notificationTypes: notificationTypes,
                                          price: price,
                                          translation: translation)
                                      .then((value) => Navigator.pop(builder)));
                        });
                  },
                  child:
                      Text(AppLocalizations.of(context).add_subscription_plan)),
            ),
            SliverToBoxAdapter(
              child: FullWidthTitle(
                  title: AppLocalizations.of(context).payment_products),
            ),
            SliverList.builder(
                itemCount: state.paymentProductItems?.length ?? 0,
                itemBuilder: (context, index) {
                  return PaymentProductTile(
                    paymentProductItem: state.paymentProductItems![index],
                  );
                }),
            SliverToBoxAdapter(
              child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            content: PaymentProductDialog(
                                onSubmit: (
                                        {required String name,
                                        required String price,
                                        required String description}) =>
                                    BlocProvider.of<AdminCubit>(context)
                                        .addPaymentProduct(
                                            name: name,
                                            price: price,
                                            description: description)
                                        .then(
                                            (value) => Navigator.pop(builder))),
                          );
                        });
                  },
                  child:
                      Text(AppLocalizations.of(context).add_payment_product)),
            ),
          ],
        ),
      );
    });
  }
}

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    super.key,
    required this.subscriptionPlan,
  });

  final SubscriptionPlan subscriptionPlan;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title:
            Text(AppLocalizations.of(context).plan_name(subscriptionPlan.name)),
        subtitle: Text(AppLocalizations.of(context).price_value(
            formatCurrency(subscriptionPlan.price, subscriptionPlan.currency))),
        trailing: OutlinedButton.icon(
          icon: const Icon(Icons.delete_forever_rounded),
          onPressed: () {
            BlocProvider.of<AdminCubit>(context)
                .deleteSubscription(subscriptionPlan.id);
          },
          label: Text(AppLocalizations.of(context).remove),
        ),
      ),
    );
  }
}

class PaymentProductTile extends StatelessWidget {
  const PaymentProductTile({
    super.key,
    required this.paymentProductItem,
  });

  final PaymentProductItem paymentProductItem;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(AppLocalizations.of(context).product_detail(
            paymentProductItem.name,
            formatCurrency(
                paymentProductItem.amount, paymentProductItem.currencyCode))),
        subtitle: Text(AppLocalizations.of(context)
            .description_text(paymentProductItem.description)),
        trailing: OutlinedButton.icon(
          icon: const Icon(Icons.delete_forever_rounded),
          onPressed: () {
            BlocProvider.of<AdminCubit>(context)
                .removePaymentProductItem(paymentProductItem.id);
          },
          label: Text(AppLocalizations.of(context).remove),
        ),
      ),
    );
  }
}

class PaymentProductDialog extends StatefulWidget {
  const PaymentProductDialog({super.key, required this.onSubmit});
  final Function({
    required String name,
    required String price,
    required String description,
  }) onSubmit;
  @override
  State<PaymentProductDialog> createState() => _PaymentProductDialogState();
}

class _PaymentProductDialogState extends State<PaymentProductDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isAllFilled = false;
  _checkIfAllFilled(String _) {
    setState(() {
      _isAllFilled = _nameController.text.isNotEmpty &&
          _priceController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty;
    });
  }

  @override
  dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          maxLines: 1,
          autofocus: true,
          onChanged: _checkIfAllFilled,
          decoration: const InputDecoration(
            hintText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
        TextFormField(
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _priceController,
          maxLines: 1,
          // ignore: prefer_const_constructors
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).price_title,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onChanged: _checkIfAllFilled,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _descriptionController,
          maxLines: 1,
          autofocus: true,
          onChanged: _checkIfAllFilled,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).description_title,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
        OutlinedButton(
            onPressed: _isAllFilled
                ? () {
                    widget.onSubmit(
                      name: _nameController.text,
                      price: _priceController.text,
                      description: _descriptionController.text,
                    );
                  }
                : null,
            child: Text(AppLocalizations.of(context).add_payment_product)),
      ],
    );
  }
}

class SubscriptionPlanDialog extends StatefulWidget {
  const SubscriptionPlanDialog(
      {super.key, required this.onSubmit, required this.currencyCode});
  final String currencyCode;
  final Function(
      {required String name,
      required String price,
      required bool translation,
      required String maxMessagingChannels,
      required String maxAnnouncement,
      required String maxInvoiceNumber,
      required String additionalInvoiceCost,
      required bool hasApartmentDocument,
      required List<String> notificationTypes,
      String? interval,
      required int intervalCount}) onSubmit;

  @override
  State<SubscriptionPlanDialog> createState() => _SubscriptionPlanDialogState();
}

class _SubscriptionPlanDialogState extends State<SubscriptionPlanDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxMessagingChannelController = TextEditingController();
  final _maxAnnouncementController = TextEditingController();
  final _maxInvoiceNumberController = TextEditingController();
  final _additionalInvoiceCostController = TextEditingController();
  bool _isAllFilled = false;
  bool _translation = false;
  bool _hasApartmentDocument = false;
  bool _isMonthly = true;
  final List<String> _notificationTypes = ['push'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _maxMessagingChannelController.dispose();
    _maxAnnouncementController.dispose();
    _maxInvoiceNumberController.dispose();
    _additionalInvoiceCostController.dispose();
    super.dispose();
  }

  _checkIfAllFilled(String _) {
    setState(() {
      _isAllFilled = _nameController.text.isNotEmpty &&
          _priceController.text.isNotEmpty &&
          _additionalInvoiceCostController.text.isNotEmpty &&
          _maxAnnouncementController.text.isNotEmpty &&
          _maxInvoiceNumberController.text.isNotEmpty &&
          _maxMessagingChannelController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    maxLines: 1,
                    autofocus: true,
                    onChanged: _checkIfAllFilled,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        onSelected: (value) {
                          setState(() {
                            _isMonthly = true;
                          });
                        },
                        label: Text(AppLocalizations.of(context).monthly_price),
                        selected: _isMonthly,
                      ),
                      ChoiceChip(
                          onSelected: (value) {
                            setState(() {
                              _isMonthly = false;
                            });
                          },
                          selected: !_isMonthly,
                          label:
                              Text(AppLocalizations.of(context).yearly_price)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _priceController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .price_value_in(widget.currencyCode.toUpperCase()),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    onChanged: _checkIfAllFilled,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                      controller: _additionalInvoiceCostController,
                      maxLines: 1,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).cost_per_invoice(
                            widget.currencyCode.toUpperCase()),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onChanged: _checkIfAllFilled),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                      controller: _maxMessagingChannelController,
                      maxLines: 1,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).max_messaging_channels,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onChanged: _checkIfAllFilled),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                      controller: _maxAnnouncementController,
                      maxLines: 1,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).max_announcements,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onChanged: _checkIfAllFilled),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                      controller: _maxInvoiceNumberController,
                      maxLines: 1,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).max_invoice_number,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onChanged: _checkIfAllFilled),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                          title: Text(
                              AppLocalizations.of(context).sms_notification),
                          value: _notificationTypes.contains('sms'),
                          onChanged: (onChanged) {
                            setState(() {
                              if (onChanged ?? false) {
                                _notificationTypes.add('sms');
                              } else {
                                _notificationTypes.remove('sms');
                              }
                            });
                          }),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                          title: Text(
                              AppLocalizations.of(context).email_notification),
                          value: _notificationTypes.contains('email'),
                          onChanged: (onChanged) {
                            setState(() {
                              if (onChanged ?? false) {
                                _notificationTypes.add('email');
                              } else {
                                _notificationTypes.remove('email');
                              }
                            });
                          }),
                    ),
                  ],
                ),
                CheckboxListTile(
                    title:
                        Text(AppLocalizations.of(context).document_translation),
                    value: _translation,
                    onChanged: (onChanged) {
                      setState(() {
                        _translation = onChanged ?? false;
                      });
                    }),
                CheckboxListTile(
                    title: Text(
                        AppLocalizations.of(context).has_apartment_documents),
                    value: _hasApartmentDocument,
                    onChanged: (onChanged) {
                      setState(() {
                        _hasApartmentDocument = onChanged ?? false;
                      });
                    }),
                Align(
                  alignment: Alignment.center,
                  child: OutlinedButton(
                      onPressed: _isAllFilled
                          ? () {
                              widget.onSubmit(
                                  name: _nameController.text,
                                  price: _priceController.text,
                                  maxMessagingChannels:
                                      _maxMessagingChannelController.text,
                                  maxAnnouncement:
                                      _maxAnnouncementController.text,
                                  maxInvoiceNumber:
                                      _maxInvoiceNumberController.text,
                                  additionalInvoiceCost:
                                      _additionalInvoiceCostController.text,
                                  translation: _translation,
                                  interval: _isMonthly ? 'month' : 'year',
                                  intervalCount: 1,
                                  hasApartmentDocument: _hasApartmentDocument,
                                  notificationTypes: _notificationTypes);
                            }
                          : null,
                      child: Text(AppLocalizations.of(context)
                          .create_new_subscription_plan)),
                )
              ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/invoice/entities/invoice_item.dart';
import 'package:priorli/presentation/invoice/invoice_creation_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_creation_state.dart';
import 'package:priorli/presentation/invoice/invoice_item_form.dart';
import 'package:priorli/presentation/invoice/payment_term.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/presentation/shared/full_width_pair_text.dart';
import 'package:priorli/presentation/shared/tap_card.dart';
import 'package:priorli/service_locator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../guest_invitation/guest_invitation.dart';
import '../shared/date_time_selector.dart';
import '../shared/setting_button.dart';

const invoiceCreationPath = 'create_invoice';

class InvoiceCreationForm extends StatefulWidget {
  const InvoiceCreationForm({super.key, required this.companyId});
  final String companyId;
  @override
  State<InvoiceCreationForm> createState() => _InvoiceCreationFormState();
}

class _InvoiceCreationFormState extends State<InvoiceCreationForm> {
  late final InvoiceCreationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<InvoiceCreationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _cubit.init(widget.companyId);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceCreationCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<InvoiceCreationCubit, InvoiceCreationState>(
          builder: (context, state) {
        return Scaffold(
            floatingActionButton: state.invoiceName?.isNotEmpty == true &&
                    state.receivers?.isNotEmpty == true &&
                    state.invoiceItemList?.isNotEmpty == true
                ? ElevatedButton(
                    child: Text(AppLocalizations.of(context).send_invoice),
                    onPressed: () {
                      _cubit.createNewInvoice().then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  AppLocalizations.of(context).invoice_sent)));
                          GoRouter.of(context).pop();
                        }
                      });
                    },
                  )
                : null,
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).send_new_invoice)),
            body: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CustomFormField(
                    hintText: AppLocalizations.of(context).invoice_name,
                    onChanged: (value) {
                      _cubit.onNameChanged(value);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [
                    Condition.largerThan(name: TABLET),
                  ],
                  child: Column(
                    children: [
                      InvoiceItemRowColumn(
                        name: AppLocalizations.of(context).item_name,
                        description:
                            AppLocalizations.of(context).item_description,
                        quantity: AppLocalizations.of(context).quantity,
                        taxPercentage: AppLocalizations.of(context).tax_rate,
                        unitCost: AppLocalizations.of(context).price_title,
                        total: AppLocalizations.of(context).total_title,
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: state.invoiceItemList?.length ?? 0,
                    (context, index) {
                  final InvoiceItem invoiceItem = state.invoiceItemList![index];
                  return InvoiceItemRowColumn(
                    name: invoiceItem.paymentProductItem.name,
                    description: invoiceItem.paymentProductItem.description,
                    quantity: invoiceItem.quantity.toStringAsFixed(2),
                    taxPercentage: invoiceItem.paymentProductItem.taxPercentage
                        .toStringAsFixed(2),
                    unitCost: invoiceItem.paymentProductItem.amount
                        .toStringAsFixed(2),
                    total: (invoiceItem.quantity *
                            invoiceItem.paymentProductItem.amount)
                        .toStringAsFixed(2),
                    onRemove: () {
                      _cubit.removeItem(index);
                    },
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            content: InvoiceItemForm(
                              onTypingInvoiceItem: (
                                  {required description,
                                  required name,
                                  required price,
                                  required quantity,
                                  required taxPercentage,
                                  required total}) {
                                _cubit.addNewInvoiceItem(
                                    name: name,
                                    description: description,
                                    price: price,
                                    quantity: quantity,
                                    taxPercentage: taxPercentage,
                                    total: total);
                                Navigator.pop(builder, true);
                              },
                            ),
                          );
                        });
                  },
                  child: Text(AppLocalizations.of(context).add_item),
                ),
              ),
              SliverToBoxAdapter(
                child: SettingButton(
                  label: Text(AppLocalizations.of(context).payment_terms),
                  icon: DropdownButton<String>(
                    enableFeedback: true,
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    value: state.paymentTerm?.name,
                    elevation: 16,
                    borderRadius: BorderRadius.circular(8),
                    underline: Container(
                      height: 0,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onChanged: (String? value) {
                      _cubit.setPaymentTerm(value ?? '');
                      if (value == PaymentTerm.custom.name) {
                        showModalBottomSheet(
                          context: context,
                          builder: (builder) => DateTimePicker(
                            initialDate: state.paymentDate,
                            onConfirmTime: (dateTime) {
                              _cubit.setPaymentDate(dateTime);
                            },
                          ),
                        );
                      }
                    },
                    items: PaymentTerm.values.map<DropdownMenuItem<String>>(
                        (PaymentTerm paymentTerm) {
                      return DropdownMenuItem<String>(
                        value: paymentTerm.name,
                        child: Text(paymentTerm.name.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: FullWidthPairText(
                label: AppLocalizations.of(context).payment_due_date(
                    getFormattedDate(
                        state.paymentDate?.millisecondsSinceEpoch ?? 0)),
                content: '',
              )),
              SliverToBoxAdapter(
                child: SettingButton(
                  label: Text(AppLocalizations.of(context).receivers(
                      state.receivers?.isNotEmpty != true
                          ? AppLocalizations.of(context).none
                          : state.receivers
                                  ?.map((e) => e.firstName)
                                  .toString() ??
                              '')),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (builder) => GuestInvitation(
                        companyId: widget.companyId,
                        initialSelectedUser:
                            state.receivers?.map((e) => e.userId).toList(),
                        onUserSelected: ({required List<User> userList}) {
                          _cubit.setReceiver(userList);
                          Navigator.pop(builder, true);
                        },
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                          contentPadding: const EdgeInsets.all(8),
                          value: state.sendEmail == true,
                          title: Text(AppLocalizations.of(context).send_email),
                          onChanged: _cubit.setSendEmail),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                          contentPadding: const EdgeInsets.all(8),
                          value: state.issueExternalInvoice == true,
                          title: Text(AppLocalizations.of(context)
                              .issue_external_invoice),
                          onChanged: _cubit.setIssueExternalInvoice),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: FullWidthPairText(
                  label: AppLocalizations.of(context).bank_accounts,
                ),
              ),
              SliverToBoxAdapter(
                child: ResponsiveRowColumn(
                  layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  children: List.generate(
                      state.bankAccountList?.length ?? 0,
                      (index) => ResponsiveRowColumnItem(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TapCard(
                                onTap: () {
                                  _cubit.selectBankAccount(
                                      state.bankAccountList?[index].id);
                                },
                                backgroundColor: state.bankAccountId ==
                                        state.bankAccountList?[index].id
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
                                    : Theme.of(context)
                                        .disabledColor
                                        .withAlpha(50),
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    state.bankAccountList?[index]
                                            .bankAccountNumber ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: state.bankAccountId ==
                                                    state
                                                        .bankAccountList?[index]
                                                        .id
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .background),
                                  )),
                                ),
                              ),
                            ),
                          )),
                ),
              )
            ]));
      }),
    );
  }
}

class InvoiceItemRowColumn extends StatelessWidget {
  const InvoiceItemRowColumn(
      {super.key,
      this.onRemove,
      required this.name,
      required this.description,
      required this.unitCost,
      required this.quantity,
      required this.taxPercentage,
      required this.total});
  final String name;
  final String description;
  final String unitCost;
  final String quantity;
  final String taxPercentage;
  final String total;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ResponsiveRowColumn(
        columnMainAxisAlignment: MainAxisAlignment.start,
        columnCrossAxisAlignment: CrossAxisAlignment.start,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
        layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: 2,
            rowFit: FlexFit.tight,
            child: Text(
              ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? AppLocalizations.of(context).item_with_name(name)
                  : name,
              textAlign: TextAlign.center,
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            rowFit: FlexFit.tight,
            child: Text(
              ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? AppLocalizations.of(context)
                      .item_with_description(description)
                  : description,
              textAlign: TextAlign.center,
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Text(
              ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? AppLocalizations.of(context).price_value(unitCost)
                  : unitCost,
              textAlign: TextAlign.center,
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Text(
              ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? AppLocalizations.of(context).quantity_with_value(quantity)
                  : quantity,
              textAlign: TextAlign.center,
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Text(
              ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? AppLocalizations.of(context)
                      .tax_rate_with_value(taxPercentage)
                  : taxPercentage,
              textAlign: TextAlign.center,
            ),
          ),
          ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: Text(
                ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? AppLocalizations.of(context).total_value(total)
                    : total,
                textAlign: TextAlign.center,
              )),
          onRemove != null
              ? ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnItem(
                      rowFlex: 1,
                      rowFit: FlexFit.tight,
                      child: Column(
                        children: [
                          TextButton.icon(
                            label: Text(AppLocalizations.of(context).remove),
                            onPressed: onRemove,
                            icon: const Icon(Icons.close),
                          ),
                          const Divider(),
                        ],
                      ))
                  : ResponsiveRowColumnItem(
                      rowFlex: 1,
                      rowFit: FlexFit.tight,
                      child: IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.close),
                      ))
              : ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Container(),
                )
        ],
      ),
    );
  }
}

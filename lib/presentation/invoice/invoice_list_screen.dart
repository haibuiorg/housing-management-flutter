import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/core/utils/time_utils.dart';
import 'package:priorli/presentation/invoice/invoice_list_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_list_state.dart';
import 'package:priorli/presentation/shared/full_width_pair_text.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/presentation/shared/pdf_viewer.dart';
import 'package:priorli/presentation/shared/popover.dart';
import 'package:priorli/service_locator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const invoiceListPath = 'invoices';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen(
      {super.key,
      this.companyId,
      required this.isPersonal,
      this.invoiceGroupId});
  final String? companyId;
  final bool isPersonal;
  final String? invoiceGroupId;

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  late final InvoiceListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _cubit.init(
          companyId: widget.companyId,
          invoiceGroupId: widget.invoiceGroupId,
          isPersonal: widget.isPersonal);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceListCubit>(
      create: (_) => _cubit,
      child: BlocConsumer<InvoiceListCubit, InvoiceListState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message!),
            ));
            _cubit.clearMessage();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context).invoices)),
            body: Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom),
                child: ResponsiveGridView.builder(
                    itemCount: state.invoiceList?.length ?? 0,
                    alignment: Alignment.center,
                    gridDelegate: const ResponsiveGridDelegate(
                        minCrossAxisExtent: 250,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24),
                    itemBuilder: (itemContext, index) {
                      final invoice = state.invoiceList![index];
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return ResendInvoiceDialog(
                                    invoice: invoice,
                                    onResend: (String email) {
                                      _cubit.resendInvoice(invoice, email).then(
                                          (value) =>
                                              Navigator.of(builder).pop());
                                    },
                                  );
                                });
                          },
                          onTap: () {
                            _cubit.getInvoiceDetail(invoice.id).then((value) {
                              if (value?.invoiceUrl?.isNotEmpty == true) {
                                (ResponsiveWrapper.of(context)
                                        .isSmallerThan(DESKTOP))
                                    ? showBottomSheet(
                                        enableDrag: true,
                                        context: context,
                                        builder: (builder) {
                                          return Popover(
                                            child: PdfViewer(
                                                link: value?.invoiceUrl ?? ''),
                                          );
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return Dialog(
                                            child: PdfViewer(
                                                link: value?.invoiceUrl ?? ''),
                                          );
                                        });
                              }
                            });
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FullWidthTitle(
                                  title: invoice.invoiceName,
                                ),
                                FullWidthPairText(
                                    label: AppLocalizations.of(context)
                                        .payment_due,
                                    content:
                                        getFormattedDate(invoice.paymentDate)),
                                FullWidthPairText(
                                    label: AppLocalizations.of(context)
                                        .reference_number_title,
                                    content: invoice.referenceNumber),
                                FullWidthPairText(
                                    label: AppLocalizations.of(context)
                                        .status_title,
                                    content: invoice.status.name),
                                Divider(
                                  height: 4,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                                FullWidthPairText(
                                  label:
                                      AppLocalizations.of(context).items_title,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                          invoice.items.length, (index) {
                                        return FullWidthPairText(
                                          label: invoice.items[index].name +
                                              invoice.items[index].description,
                                          content: invoice.items[index].total
                                              .toString(),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 4,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                                FullWidthPairText(
                                    label: AppLocalizations.of(context)
                                        .amount_title,
                                    content: invoice.subtotal.toString()),
                              ]),
                        ),
                      );
                    })),
          );
        },
      ),
    );
  }
}

class ResendInvoiceDialog extends StatefulWidget {
  const ResendInvoiceDialog({super.key, required this.invoice, this.onResend});
  final Invoice invoice;
  final Function(String emails)? onResend;

  @override
  State<ResendInvoiceDialog> createState() => _ResendInvoiceDialogState();
}

class _ResendInvoiceDialogState extends State<ResendInvoiceDialog> {
  final _emailController = TextEditingController();
  bool isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    isSending = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).resend_invoice),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          !isSending
              ? TextFormField(
                  validator: (value) {
                    if (value?.isValidEmail != true) {
                      return AppLocalizations.of(context).email_address_error;
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).email,
                  ),
                )
              : const CircularProgressIndicator()
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).cancel)),
        TextButton(
            onPressed: () {
              if (_emailController.text.isValidEmail) {
                setState(() {
                  isSending = true;
                });
                widget.onResend?.call(_emailController.text);
              }
            },
            child: Text(AppLocalizations.of(context).send))
      ],
    );
  }
}

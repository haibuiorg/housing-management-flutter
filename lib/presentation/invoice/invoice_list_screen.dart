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
            appBar: AppBar(title: const Text('Invoices')),
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
                                    label: 'Payment date',
                                    content:
                                        getFormattedDate(invoice.paymentDate)),
                                FullWidthPairText(
                                    label: 'Refence number:',
                                    content: invoice.referenceNumber),
                                FullWidthPairText(
                                    label: 'Status:',
                                    content: invoice.status.name),
                                Divider(
                                  height: 4,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                                const FullWidthPairText(
                                  label: 'Items:',
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
                                    label: 'Amount',
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
  const ResendInvoiceDialog({super.key, required this.invoice});
  final Invoice invoice;

  @override
  State<ResendInvoiceDialog> createState() => _ResendInvoiceDialogState();
}

class _ResendInvoiceDialogState extends State<ResendInvoiceDialog> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resend invoice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Send invoice to this email address:'),
          TextFormField(
            validator: (value) {
              if (value?.isValidEmail != true) {
                return 'Please enter email address';
              }
              return null;
            },
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Email address',
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              BlocProvider.of<InvoiceListCubit>(context)
                  .resendInvoice(widget.invoice, _emailController.text)
                  .then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Send'))
      ],
    );
  }
}

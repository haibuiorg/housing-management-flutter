import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/time_utils.dart';
import 'package:priorli/presentation/invoice/invoice_list_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_list_state.dart';
import 'package:priorli/presentation/shared/app_gallery.dart';
import 'package:priorli/presentation/shared/full_width_pair_text.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/presentation/shared/pdf_viewer.dart';
import 'package:priorli/presentation/shared/popover.dart';
import 'package:priorli/presentation/shared/tap_card.dart';
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
      child: BlocBuilder<InvoiceListCubit, InvoiceListState>(
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

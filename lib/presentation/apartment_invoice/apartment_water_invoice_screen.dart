import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/apartment_invoice/apartment_water_invoice_state.dart';
import 'package:priorli/presentation/shared/pdf_viewer.dart';
import 'package:priorli/service_locator.dart';
import '../shared/setting_button.dart';
import 'apartment_water_invoice_cubit.dart';

const apartmentWaterInvoice = 'water_bill';

class ApartmentWaterInvoiceScreen extends StatefulWidget {
  const ApartmentWaterInvoiceScreen(
      {super.key, required this.companyId, required this.apartmentId});
  final String companyId;
  final String apartmentId;

  @override
  State<ApartmentWaterInvoiceScreen> createState() =>
      _ApartmentWaterInvoiceScreenState();
}

class _ApartmentWaterInvoiceScreenState
    extends State<ApartmentWaterInvoiceScreen> {
  final ApartmentWaterInvoiceCubit cubit =
      serviceLocator<ApartmentWaterInvoiceCubit>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    await cubit.init(widget.companyId, widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApartmentWaterInvoiceCubit>(
      create: (_) => cubit,
      child:
          BlocConsumer<ApartmentWaterInvoiceCubit, ApartmentWaterInvoiceState>(
              listener: (context, state) {
        if (state.waterBillLink != null &&
            state.waterBillLink?.isNotEmpty == true) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return FractionallySizedBox(
                    heightFactor: 0.9,
                    child: PdfViewer(
                      link: state.waterBillLink ?? '',
                    ));
              });
        }
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Water invoices'),
            ),
            body: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  Text(state.waterBillList?.isNotEmpty == true
                      ? state.waterBillList![0].year.toString()
                      : DateTime.now().year.toString()),
                  Expanded(
                      child: ListView.builder(
                          itemCount: state.waterBillList?.length ?? 0,
                          itemBuilder: (context, index) => SettingButton(
                                icon: Icon(
                                  Icons.file_open_rounded,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                onPressed: (() =>
                                    cubit.getWaterBillLink(index)),
                                label: Text(
                                    'Water invoice for period ${state.waterBillList?[index].period}/${state.waterBillList?[index].year}'),
                              ))),
                ],
              ),
            ));
      }),
    );
  }
}

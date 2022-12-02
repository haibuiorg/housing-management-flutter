import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/presentation/apartments/apartment_cubit.dart';
import 'package:priorli/presentation/apartments/apartment_state.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/utils/string_extension.dart';
import '../apartment_invoice/apartment_water_invoice_screen.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import '../shared/custom_form_field.dart';
import '../shared/full_width_pair_text.dart';

const apartmentScreenPath = 'apartment';

class ApartmentScreen extends StatefulWidget {
  const ApartmentScreen({super.key, required this.apartmentId});
  final String apartmentId;

  @override
  State<ApartmentScreen> createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  late final ApartmentCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = serviceLocator<ApartmentCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  _getInitialData() async {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];

    await cubit.init(housingCompanyId, widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApartmentCubit>(
      create: (_) => cubit,
      child: BlocConsumer<ApartmentCubit, ApartmentState>(
          listener: (context, state) {
        if (state.newConsumptionAdded == true) {}
      }, builder: (context, state) {
        final hasConsumptionValue =
            state.yearlyWaterBills?.isNotEmpty == true &&
                state.yearlyWaterBills
                        ?.where((element) =>
                            element.period ==
                                state.latestWaterConsumption?.period &&
                            element.year == state.latestWaterConsumption?.year)
                        .isNotEmpty ==
                    true;

        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  context.push(
                      '${GoRouter.of(context).location}/$manageScreenPath');
                },
                child: const Text('More'),
              )
            ],
            title: Text(
                '${state.apartment?.building ?? 'Apartment'} ${state.apartment?.houseCode ?? ''}'),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Water consumption',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    enableAxisAnimation: true,
                    series: <CartesianSeries<WaterBill, int>>[
                      ColumnSeries<WaterBill, int>(
                          // Bind data source
                          animationDuration: 1500,
                          color: Theme.of(context).colorScheme.primary,
                          dataSource: state.yearlyWaterBills ?? [],
                          xValueMapper: (WaterBill waterConsumption, _) =>
                              waterConsumption.period,
                          yValueMapper: (WaterBill waterConsumption, _) =>
                              waterConsumption.consumption),
                    ]),
              ),
              SettingButton(
                onPressed: () {
                  context.push(
                      '${GoRouter.of(context).location}/$apartmentWaterInvoice');
                },
                label: const Text('Archived invoices'),
              ),
              FullWidthPairText(
                label: 'Period',
                content: state.latestWaterConsumption?.period.toString() ?? '',
              ),
              FullWidthPairText(
                label: 'Year',
                content: state.latestWaterConsumption?.year.toString() ?? '',
              ),
              FullWidthPairText(
                label: 'Basic fee',
                content: formatCurrency(
                    ((state.latestWaterConsumption?.basicFee ?? 0) /
                        (state.housingCompany?.apartmentCount ?? 1)),
                    state.housingCompany?.currencyCode),
              ),
              FullWidthPairText(
                label: 'Price per cube',
                content: formatCurrency(
                    state.latestWaterConsumption?.pricePerCube,
                    state.housingCompany?.currencyCode),
              ),
              hasConsumptionValue
                  ? Column(
                      children: [
                        FullWidthPairText(
                          label: 'Your consumption this period',
                          content: state.yearlyWaterBills
                                  ?.where((element) =>
                                      element.period ==
                                          state
                                              .latestWaterConsumption?.period &&
                                      element.year ==
                                          state.latestWaterConsumption?.year)
                                  .first
                                  .consumption
                                  .toStringAsFixed(2) ??
                              'Not yet updated',
                        ),
                        FullWidthPairText(
                            label: 'Your invoice this period',
                            content: formatCurrency(
                                state.yearlyWaterBills
                                    ?.where((element) =>
                                        element.period ==
                                            state.latestWaterConsumption
                                                ?.period &&
                                        element.year ==
                                            state.latestWaterConsumption?.year)
                                    .first
                                    .invoiceValue,
                                state.housingCompany?.currencyCode)),
                      ],
                    )
                  : const FullWidthPairText(
                      label: 'Your consumption this period',
                      content: 'Not yet updated',
                    ),
              OutlinedButton(
                  onPressed: hasConsumptionValue ||
                          state.latestWaterConsumption == null
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (_) => ConsumptionValueDialog(
                                    onSubmit: ({
                                      required consumption,
                                    }) async {
                                      await cubit.addLatestConsumptionValue(
                                          double.parse(consumption));
                                      await _getInitialData();
                                    },
                                  ));
                        },
                  child: const Text('Add water consumption for this period'))
            ]),
          ),
        );
      }),
    );
  }
}

class ConsumptionValueDialog extends StatefulWidget {
  const ConsumptionValueDialog({super.key, required this.onSubmit});
  final Function({
    required String consumption,
  }) onSubmit;

  @override
  State<ConsumptionValueDialog> createState() => _ConsumptionValueDialogState();
}

class _ConsumptionValueDialogState extends State<ConsumptionValueDialog> {
  final _consumptionController = TextEditingController();
  @override
  void dispose() {
    _consumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add consumption value for this period'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Consumption value',
          textEditingController: _consumptionController,
        )
      ]),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onSubmit(
                consumption: _consumptionController.text,
              );
              Navigator.pop(context, true);
            },
            child: const Text('Submit'))
      ],
    );
  }
}

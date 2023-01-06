import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/presentation/water_consumption_management/water_consumption_management_state.dart';
import 'package:priorli/service_locator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../../core/utils/string_extension.dart';
import 'water_consumption_management_cubit.dart';

const waterConsumptionManagementScreenPath = 'water_consumption_management';

class WaterConsumptionManagementScreen extends StatelessWidget {
  const WaterConsumptionManagementScreen(
      {super.key, required this.housingCompanyId});
  final String housingCompanyId;
  @override
  Widget build(BuildContext context) {
    final cubit = serviceLocator<WaterConsumptionManagementCubit>();
    cubit.init(housingCompanyId);
    return BlocProvider<WaterConsumptionManagementCubit>(
      create: (_) => cubit,
      child: BlocConsumer<WaterConsumptionManagementCubit,
          WaterConsumptionManagementState>(listener: (context, state) {
        if (state.finishManagement == true) {}
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Water consumption'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SfCartesianChart(
                        title: ChartTitle(
                            text: 'Water price history',
                            textStyle: Theme.of(context).textTheme.titleMedium),
                        // Initialize category axis
                        primaryXAxis: DateTimeCategoryAxis(),
                        series: <LineSeries<WaterPrice, DateTime>>[
                          LineSeries<WaterPrice, DateTime>(
                              // Bind data source
                              dataSource: state.waterPriceHistory ?? [],
                              xValueMapper: (WaterPrice price, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      price.updatedOn),
                              yValueMapper: (WaterPrice price, _) =>
                                  price.pricePerCube),
                          LineSeries<WaterPrice, DateTime>(
                              // Bind data source
                              dataSource: state.waterPriceHistory ?? [],
                              sortFieldValueMapper: (datum, index) => index,
                              xValueMapper: (WaterPrice price, _) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      price.updatedOn),
                              yValueMapper: (WaterPrice price, _) =>
                                  price.basicFee)
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current water price:'),
                            Text(
                                'Per cube: ${formatCurrency(state.activeWaterPrice?.pricePerCube, state.housingCompany?.currencyCode)}'),
                            Text(
                                'Basic fee: ${formatCurrency(state.activeWaterPrice?.basicFee, state.housingCompany?.currencyCode)}'),
                          ],
                        ),
                        if (state.housingCompany?.isUserManager == true)
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => WaterPriceDialog(
                                          onSubmit: (
                                              {required basicFee,
                                              required pricePerCube}) async {
                                            await cubit.addNewWaterPrice(
                                                basicFee, pricePerCube);
                                          },
                                        ));
                              },
                              child: const Text('Add new water price')),
                      ],
                    ),
                    const Divider(),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Current water bill period',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Text(
                        'Total reading: ${state.latestWaterConsumption?.totalReading ?? 'Unknown'}'),
                    Text(
                        'Total basic fee: ${formatCurrency(state.latestWaterConsumption?.basicFee, state.housingCompany?.currencyCode)}'),
                    Text(
                        'Price per cub: ${formatCurrency(state.latestWaterConsumption?.pricePerCube, state.housingCompany?.currencyCode)}'),
                    Text(
                        'Period: ${state.latestWaterConsumption?.period ?? 'Unknown'}'),
                    Text(
                        'Year: ${state.latestWaterConsumption?.year ?? 'Unknown'}'),
                    Text(
                        'Progress: ${state.latestWaterConsumption?.consumptionValues?.length ?? '0'}/${state.housingCompany?.apartmentCount ?? '0'}'),
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: LiquidCircularProgressIndicator(
                              value: (state.latestWaterConsumption
                                          ?.consumptionValues?.length ??
                                      0) /
                                  ((state.housingCompany?.apartmentCount ?? 0) >
                                          0
                                      ? state.housingCompany?.apartmentCount ??
                                          1
                                      : 1), // Defaults to 0.5.
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary),
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              borderColor:
                                  Theme.of(context).colorScheme.secondary,
                              borderWidth: 1,
                              direction: Axis.vertical,
                            ),
                          ),
                          if (state.housingCompany?.isUserManager == true)
                            OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => WaterConsumptionDialog(
                                            showIncompleteError: (state
                                                        .latestWaterConsumption
                                                        ?.consumptionValues
                                                        ?.length ??
                                                    0) <
                                                (state.housingCompany
                                                        ?.apartmentCount ??
                                                    0),
                                            onSubmit: ({
                                              required totalReading,
                                            }) async {
                                              await cubit
                                                  .startNewWaterBillPeriod(
                                                      totalReading);
                                            },
                                          ));
                                },
                                child:
                                    const Text('Start new water bill period')),
                        ],
                      ),
                    ),
                  ]),
            ));
      }),
    );
  }
}

class WaterConsumptionDialog extends StatefulWidget {
  const WaterConsumptionDialog(
      {super.key, required this.onSubmit, required this.showIncompleteError});
  final bool showIncompleteError;
  final Function({
    required double totalReading,
  }) onSubmit;

  @override
  State<WaterConsumptionDialog> createState() => _WaterConsumptionDialogState();
}

class _WaterConsumptionDialogState extends State<WaterConsumptionDialog> {
  final _totalReadingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.showIncompleteError
          ? Text(
              'Warning! Current period is not completed!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            )
          : const Text('Start new water bill period'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Total reading',
          textEditingController: _totalReadingController,
        ),
      ]),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onSubmit(
                totalReading: double.parse(_totalReadingController.text),
              );
              Navigator.pop(context, true);
            },
            child: const Text('Start'))
      ],
    );
  }
}

class WaterPriceDialog extends StatefulWidget {
  const WaterPriceDialog({super.key, required this.onSubmit});
  final Function({required String basicFee, required String pricePerCube})
      onSubmit;

  @override
  State<WaterPriceDialog> createState() => _WaterPriceDialogState();
}

class _WaterPriceDialogState extends State<WaterPriceDialog> {
  final _perCubeController = TextEditingController();
  final _basicFeeController = TextEditingController();
  @override
  void dispose() {
    _perCubeController.dispose();
    _basicFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new water price'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Per cube',
          textEditingController: _perCubeController,
        ),
        CustomFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Basic fee',
          textEditingController: _basicFeeController,
        )
      ]),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onSubmit(
                  basicFee: _basicFeeController.text,
                  pricePerCube: _perCubeController.text);
              Navigator.pop(context, true);
            },
            child: const Text('Submit'))
      ],
    );
  }
}

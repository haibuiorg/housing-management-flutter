import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/apartments/apartment_cubit.dart';
import 'package:priorli/presentation/apartments/apartment_state.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/string_extension.dart';
import '../apartment_invoice/apartment_water_invoice_screen.dart';
import '../documents/document_list_screen.dart';
import '../file_selector/file_selector.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import '../message/message_screen.dart';
import '../shared/app_gallery.dart';
import '../shared/custom_form_field.dart';
import '../shared/full_width_pair_text.dart';

const apartmentScreenPath = 'apartment';

class ApartmentScreen extends StatefulWidget {
  const ApartmentScreen(
      {super.key, required this.apartmentId, required this.companyId});
  final String apartmentId;
  final String companyId;

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
    await cubit.init(widget.companyId, widget.apartmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApartmentCubit>(
      create: (_) => cubit,
      child: BlocConsumer<ApartmentCubit, ApartmentState>(
          listener: (context, state) {
        if (state.newFaultReport != null) {
          GoRouter.of(context).push(
              '$messagePath/${state.newFaultReport!.type}/${state.newFaultReport!.channelId}/${state.newFaultReport!.id}');
        }
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
                  context.pushFromCurrentLocation(manageScreenPath);
                },
                child: Text(AppLocalizations.of(context).more),
              )
            ],
            title: Text(
                '${state.apartment?.building ?? AppLocalizations.of(context).apartment} ${state.apartment?.houseCode ?? ''}'),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  FullWidthTitle(
                    title: AppLocalizations.of(context).water_consumption,
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
                      context.pushFromCurrentLocation(apartmentWaterInvoice);
                    },
                    label: Text(AppLocalizations.of(context).archived_invoices),
                  ),
                  FullWidthPairText(
                    label: AppLocalizations.of(context).period,
                    content:
                        state.latestWaterConsumption?.period.toString() ?? '',
                  ),
                  FullWidthPairText(
                    label: AppLocalizations.of(context).year,
                    content:
                        state.latestWaterConsumption?.year.toString() ?? '',
                  ),
                  FullWidthPairText(
                    label: AppLocalizations.of(context).basic_fee,
                    content: formatCurrency(
                        ((state.latestWaterConsumption?.basicFee ?? 0) /
                            (state.housingCompany?.apartmentCount ?? 1)),
                        state.housingCompany?.currencyCode),
                  ),
                  FullWidthPairText(
                    label: AppLocalizations.of(context).price_per_cube,
                    content: formatCurrency(
                        state.latestWaterConsumption?.pricePerCube,
                        state.housingCompany?.currencyCode),
                  ),
                  hasConsumptionValue
                      ? Column(
                          children: [
                            FullWidthPairText(
                              label: AppLocalizations.of(context)
                                  .consumption_this_period,
                              content: state.yearlyWaterBills
                                      ?.where((element) =>
                                          element.period ==
                                              state.latestWaterConsumption
                                                  ?.period &&
                                          element.year ==
                                              state
                                                  .latestWaterConsumption?.year)
                                      .first
                                      .consumption
                                      .toStringAsFixed(2) ??
                                  AppLocalizations.of(context).not_yet_updated,
                            ),
                            FullWidthPairText(
                                label: AppLocalizations.of(context)
                                    .invoice_this_period,
                                content: formatCurrency(
                                    state.yearlyWaterBills
                                        ?.where((element) =>
                                            element.period ==
                                                state.latestWaterConsumption
                                                    ?.period &&
                                            element.year ==
                                                state.latestWaterConsumption
                                                    ?.year)
                                        .first
                                        .invoiceValue,
                                    state.housingCompany?.currencyCode)),
                          ],
                        )
                      : FullWidthPairText(
                          label: AppLocalizations.of(context)
                              .consumption_this_period,
                          content: AppLocalizations.of(context).not_yet_updated,
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
                      child: Text(
                          AppLocalizations.of(context).add_water_consumption)),
                  FullWidthTitle(
                    title: AppLocalizations.of(context).documents,
                  ),
                ]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final document = state.documentList?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: document != null
                        ? SettingButton(
                            onPressed: () {
                              cubit
                                  .getDocument(
                                      state.documentList?[index].id ?? '')
                                  .then((value) => showBottomSheet(
                                      context: context,
                                      builder: (builder) => AppGallery(
                                          galleryItems:
                                              value != null ? [value] : [])));
                            },
                            label: Text(
                              state.documentList?[index].name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                },
                childCount: state.documentList?.length ?? 0,
              )),
              SliverToBoxAdapter(
                  child: TextButton(
                      onPressed: () {
                        context.pushFromCurrentLocation(documentListScreenPath);
                      },
                      child: Text(AppLocalizations.of(context).more))),
              SliverToBoxAdapter(
                child: SettingButton(
                  label: Text(AppLocalizations.of(context).fault_report),
                  onPressed: () {
                    showBottomSheet(
                        context: context,
                        builder: (builder) => Scaffold(
                              body: FaultReportDialog(onSubmit: (
                                  {required String title,
                                  required String body,
                                  required bool sendEmail,
                                  List<String>? uploadedDocuments}) {
                                cubit
                                    .createNewFaultReport(
                                        title: title,
                                        description: body,
                                        sendEmail: sendEmail,
                                        storageItems: uploadedDocuments)
                                    .then((value) =>
                                        Navigator.pop(builder, true));
                              }),
                            ));
                  },
                ),
              )
            ],
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
      title: Text(AppLocalizations.of(context).add_consumption_value),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: AppLocalizations.of(context).consumption_value,
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
            child: Text(AppLocalizations.of(context).submit))
      ],
    );
  }
}

class FaultReportDialog extends StatefulWidget {
  const FaultReportDialog({super.key, required this.onSubmit});
  final Function(
      {required String title,
      required String body,
      required bool sendEmail,
      List<String>? uploadedDocuments}) onSubmit;

  @override
  State<FaultReportDialog> createState() => _FaultReportDialogState();
}

class _FaultReportDialogState extends State<FaultReportDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sendEmail = false;
  List<String> _uploadedDocuments = [];
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
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
                Text(
                  AppLocalizations.of(context).fault_report,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _titleController,
                    maxLines: 1,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).title,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _bodyController,
                  minLines: 5,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).content,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                FileSelector(
                  onCompleteUploaded: (onCompleteUploaded) {
                    setState(() {
                      _uploadedDocuments = onCompleteUploaded;
                    });
                  },
                  autoUpload: true,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _sendEmail,
                        onChanged: (onChanged) {
                          setState(() {
                            _sendEmail = !_sendEmail;
                          });
                        }),
                    Text(AppLocalizations.of(context).also_send_email),
                    const Spacer(),
                    OutlinedButton(
                        onPressed: () {
                          widget.onSubmit(
                              sendEmail: _sendEmail,
                              body: _bodyController.text,
                              title: _titleController.text,
                              uploadedDocuments: _uploadedDocuments);
                        },
                        child: Text(AppLocalizations.of(context).submit))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

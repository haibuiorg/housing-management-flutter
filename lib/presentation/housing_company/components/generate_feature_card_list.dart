import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/housing_company/components/create_new_channel_dialog.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/water_usage/entities/water_consumption.dart';
import '../../add_apartment/add_apartment_screen.dart';
import '../../apartments/apartment_screen.dart';
import '../../documents/document_list_screen.dart';
import '../../invoice/invoice_creation_form.dart';
import '../../invoice/invoice_group_list_screen.dart';
import '../../invoice/invoice_list_screen.dart';
import '../../message/message_screen.dart';
import '../../polls/poll_screen.dart';
import '../../shared/conversation_item.dart';
import '../../shared/document_detail_dialog.dart';
import '../../shared/full_width_title.dart';
import '../../shared/setting_button.dart';
import '../../water_consumption_management/water_consumption_management_screen.dart';
import '../housing_company_state.dart';
import 'apartment_tile.dart';
import 'poll_chart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<Widget> createFeatureWidgetList(
        BuildContext context, HousingCompanyState state) =>
    [
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.communication_topic,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.conversationList?.length ?? 0,
                itemBuilder: (context, index) {
                  final conversation = state.conversationList?[index];
                  return conversation != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConversationItem(
                            onPressed: () => GoRouter.of(context).push(
                                '$messagePath/${conversation.type}/${conversation.channelId}/${conversation.id}'),
                            conversation: conversation,
                          ),
                        )
                      : const SizedBox.shrink();
                }),
          ),
          TextButton(
              onPressed: state.housingCompany?.isUserManager == true
                  ? () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return CreateNewChannelDialog(
                              onConfirmed: (channelName) {
                                BlocProvider.of<HousingCompanyCubit>(context)
                                    .startNewChannel(channelName);
                                Navigator.pop(builder, true);
                              },
                            );
                          });
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.start_new_channel))
        ],
      ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.water_consumption,
            action: InkWell(
                onTap: () {
                  context.pushFromCurrentLocation(
                      waterConsumptionManagementScreenPath);
                },
                child: const Icon(Icons.water_drop_outlined)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: SfCartesianChart(
                  // Initialize category axis
                  primaryXAxis: CategoryAxis(),
                  enableAxisAnimation: true,
                  series: <CartesianSeries<WaterConsumption, int>>[
                    ColumnSeries<WaterConsumption, int>(
                        // Bind data source
                        animationDuration: 1500,
                        color: Theme.of(context).colorScheme.primary,
                        dataSource: state.yearlyWaterConsumption ?? [],
                        xValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.period,
                        yValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.totalReading),
                    SplineSeries<WaterConsumption, int>(
                        animationDuration: 1500,
                        dataSource: state.yearlyWaterConsumption ?? [],
                        xValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.period,
                        yValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.pricePerCube),
                    SplineSeries<WaterConsumption, int>(
                        animationDuration: 1500,
                        dataSource: state.yearlyWaterConsumption ?? [],
                        xValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.period,
                        yValueMapper: (WaterConsumption waterConsumption, _) =>
                            waterConsumption.basicFee),
                  ]),
            ),
          ),
        ],
      ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.apartment,
            action: OutlinedButton.icon(
              onPressed: state.housingCompany?.isUserManager == true
                  ? () {
                      context.pushFromCurrentLocation(addApartmentPath);
                    }
                  : null,
              icon: const Icon(Icons.add_home),
              label: Text(AppLocalizations.of(context)!.add),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: state.apartmentList?.length ?? 0,
              itemBuilder: (context, index) {
                return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.pushFromCurrentLocation(
                          '$apartmentScreenPath/${state.apartmentList?[index].id}');
                    },
                    child: ApartmentTile(
                      apartment: state.apartmentList![index],
                    ));
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.documents,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.documentList?.length ?? 0,
                itemBuilder: (context, index) {
                  final document = state.documentList?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: document != null
                        ? DocumentDetailCard(
                            document: state.documentList![index])
                        : const SizedBox.shrink(),
                  );
                }),
          ),
          TextButton(
              onPressed: () {
                context.pushFromCurrentLocation(documentListScreenPath);
              },
              child: Text(AppLocalizations.of(context)!.more))
        ],
      ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.polls,
            action: TextButton(
              onPressed: state.housingCompany?.isUserManager == true
                  ? () {
                      context.pushFromCurrentLocation(pollScreenPath);
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.create_new_poll),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.ongoingPollList?.length ?? 0,
                itemBuilder: (context, index) {
                  final poll = state.ongoingPollList?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: poll != null
                        ? Column(
                            children: [
                              SettingButton(
                                onPressed: () {
                                  context.pushFromCurrentLocation(
                                      '$pollScreenPath/${poll.id}');
                                },
                                label: Text(
                                  state.ongoingPollList?[index].name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PollChart(poll: poll)
                            ],
                          )
                        : const SizedBox.shrink(),
                  );
                }),
          ),
          TextButton(
              onPressed: () {}, child: Text(AppLocalizations.of(context)!.more))
        ],
      ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.fault_report,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.faultReportList?.length ?? 0,
                itemBuilder: (context, index) {
                  final faultReport = state.faultReportList?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        GoRouter.of(context).push(
                            '$messagePath/${faultReport!.type}/${faultReport.channelId}/${faultReport.id}');
                      },
                      title: Text(faultReport?.name ?? ''),
                      subtitle: Text((faultReport?.status ?? '').capitalize()),
                      leading: Icon(Icons.report,
                          color: faultReport?.status == 'pending'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }),
          ),
        ],
      ),
      if (state.housingCompany?.isUserManager == true)
        Column(
          children: [
            FullWidthTitle(
              title: AppLocalizations.of(context)!.invoices,
              action: TextButton.icon(
                  onPressed: () {
                    context.pushFromCurrentLocation(invoiceCreationPath);
                  },
                  icon: const Icon(Icons.receipt),
                  label: Text(AppLocalizations.of(context)!.new_invoice)),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: state.invoiceGroupList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final invoiceGroup = state.invoiceGroupList?[index];
                    return invoiceGroup != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SettingButton(
                              onPressed: () {
                                context.pushFromCurrentLocation(
                                    '/company/$invoiceListPath/${invoiceGroup.id}');
                              },
                              label: Text(invoiceGroup.invoiceName),
                            ))
                        : const SizedBox.shrink();
                  }),
            ),
            TextButton(
                onPressed: () {
                  context.pushFromCurrentLocation(invoiceGroupPath);
                },
                child: Text(AppLocalizations.of(context)!.more))
          ],
        ),
      Column(
        children: [
          FullWidthTitle(
            title: AppLocalizations.of(context)!.renovation_requests,
          )
        ],
      ),
    ];

class DocumentDetailCard extends StatelessWidget {
  const DocumentDetailCard({
    super.key,
    required this.document,
  });
  final StorageItem document;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
        builder: (context, state) {
      return Card(
        child: ListTile(
          onTap: () {
            BlocProvider.of<HousingCompanyCubit>(context)
                .getDocument(document.id ?? '')
                .then((value) => showDialog(
                    context: context,
                    builder: (builder) =>
                        DocumentDetailDialog(document: value!)));
          },
          title: Text(
            document.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          subtitle: Text(
            document.summaryTranslation
                    ?.firstWhere((element) =>
                        element.languageCode ==
                        BlocProvider.of<SettingCubit>(context)
                            .state
                            .languageCode)
                    .value ??
                '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}

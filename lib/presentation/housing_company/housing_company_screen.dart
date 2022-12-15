import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../announcement/announcement_screen.dart';
import '../apartments/apartment_screen.dart';
import '../documents/document_list_screen.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import '../announcement/announcement_item.dart';
import '../message/message_screen.dart';
import '../shared/conversation_item.dart';
import '../water_consumption_management/water_consumption_management_screen.dart';

const housingCompanyScreenPath = 'housing_company';

class HousingCompanyScreen extends StatefulWidget {
  const HousingCompanyScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;

  @override
  State<HousingCompanyScreen> createState() => _HousingCompanyScreenState();
}

class _HousingCompanyScreenState extends State<HousingCompanyScreen> {
  late final HousingCompanyCubit cubit;

  @override
  void initState() {
    cubit = serviceLocator<HousingCompanyCubit>();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  _showNewChannelCreationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CreateNewChannelDialog(
            onConfirmed: (channelName) {
              cubit.startNewChannel(channelName);
              Navigator.pop(context, true);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    cubit.init(widget.housingCompanyId);
    return BlocProvider<HousingCompanyCubit>(
      create: (_) => cubit,
      child: BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
          builder: (context, state) {
        if (state.housingCompany?.ui != null) {
          BlocProvider.of<SettingCubit>(context)
              .updateUIFromCompany(state.housingCompany?.ui);
        }
        return Scaffold(
            body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: CustomScrollView(clipBehavior: Clip.none, slivers: [
            SliverAppBar(
              elevation: 8,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$manageScreenPath');
                    },
                    label: const Text('Manage'),
                  ),
                )
              ],
              expandedHeight: MediaQuery.of(context).size.height / 4,
              floating: true,
              pinned: true,
              title: Text(
                state.housingCompany?.name ?? 'Housing company',
              ),
              forceElevated: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                tag: widget.housingCompanyId,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: state.housingCompany?.coverImageUrl ?? '',
                  errorWidget: (context, url, error) => Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: const AppLottieAnimation(
                      loadingResource: 'apartment',
                    ),
                  ),
                ),
              )),
            ),
            const SliverToBoxAdapter(
                child: FullWidthTitle(
              title: 'Announcements',
            )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final announcement = state.announcementList?[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: announcement != null
                      ? AnnouncementItem(
                          companyId: state.housingCompany?.id ?? '',
                          announcement: announcement,
                        )
                      : const SizedBox.shrink(),
                );
              },
              childCount: (state.announcementList?.length ?? 0),
            )),
            SliverToBoxAdapter(
                child: TextButton(
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$announcementPath');
                    },
                    child: const Text('More'))),
            const SliverToBoxAdapter(
                child: FullWidthTitle(
              title: 'Communication channels',
            )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final conversation = state.conversationList?[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: conversation != null
                      ? ConversationItem(
                          onPressed: () => GoRouter.of(context).push(
                              '$messagePath/${conversation.type}/${conversation.channelId}/${conversation.id}'),
                          conversation: conversation,
                        )
                      : const SizedBox.shrink(),
                );
              },
              childCount: state.conversationList?.length ?? 0,
            )),
            SliverToBoxAdapter(
                child: TextButton(
                    onPressed: () {
                      _showNewChannelCreationDialog();
                    },
                    child: const Text('Start new channels'))),
            SliverToBoxAdapter(
              child: FullWidthTitle(
                title: 'Water consumption',
                action: OutlinedButton.icon(
                    icon: const Icon(Icons.water_drop_outlined),
                    onPressed: () {
                      context.push(
                          '${GoRouter.of(context).location}/$waterConsumptionManagementScreenPath');
                    },
                    label: const Text('Detail')),
              ),
            ),
            SliverToBoxAdapter(
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
                          xValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.period,
                          yValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.totalReading),
                      SplineSeries<WaterConsumption, int>(
                          animationDuration: 1500,
                          dataSource: state.yearlyWaterConsumption ?? [],
                          xValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.period,
                          yValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.pricePerCube),
                      SplineSeries<WaterConsumption, int>(
                          animationDuration: 1500,
                          dataSource: state.yearlyWaterConsumption ?? [],
                          xValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.period,
                          yValueMapper:
                              (WaterConsumption waterConsumption, _) =>
                                  waterConsumption.basicFee),
                    ]),
              ),
            ),
            SliverToBoxAdapter(
                child: FullWidthTitle(
              title: 'Apartment',
              action: OutlinedButton.icon(
                onPressed: () {
                  context.push(
                      '${GoRouter.of(context).location}/$addApartmentPath');
                },
                icon: const Icon(Icons.add_home),
                label: const Text('Add'),
              ),
            )),
            SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  childAspectRatio: 21 / 9,
                  crossAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        context.push(
                            '${GoRouter.of(context).location}/$apartmentScreenPath/${state.apartmentList?[index].id}');
                      },
                      child: ApartmentTile(
                        apartment: state.apartmentList![index],
                      ));
                }, childCount: state.apartmentList?.length ?? 0)),
            SliverToBoxAdapter(
                child: FullWidthTitle(
              title: 'Document',
              action: OutlinedButton.icon(
                onPressed: () {
                  context.push(
                      '${GoRouter.of(context).location}/$documentListScreenPath');
                },
                icon: const Icon(Icons.document_scanner_rounded),
                label: const Text('More'),
              ),
            )),
            const SliverToBoxAdapter(
                child: FullWidthTitle(
              title: 'Polls',
            )),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: AppLottieAnimation(
                  loadingResource: 'vote',
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: FullWidthTitle(
                title: 'Events',
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: AppLottieAnimation(
                  loadingResource: 'checking_calendar',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fault report',
                        style: Theme.of(context).textTheme.displaySmall),
                  ],
                ),
              ),
            ),
          ]),
        ));
      }),
    );
  }
}

class CreateNewChannelDialog extends StatefulWidget {
  const CreateNewChannelDialog({super.key, required this.onConfirmed});
  final Function(String channelName) onConfirmed;

  @override
  State<CreateNewChannelDialog> createState() => _CreateNewChannelDialogState();
}

class _CreateNewChannelDialogState extends State<CreateNewChannelDialog> {
  late final TextEditingController _channelName;

  @override
  void initState() {
    _channelName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _channelName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new channel'),
      content: CustomFormField(
        textEditingController: _channelName,
        hintText: 'Channel name',
      ),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onConfirmed(_channelName.text);
            },
            child: const Text('Confirm'))
      ],
    );
  }
}

class ApartmentTile extends StatefulWidget {
  const ApartmentTile({super.key, required this.apartment});
  final Apartment apartment;
  @override
  State<ApartmentTile> createState() => _ApartmentTileState();
}

class _ApartmentTileState extends State<ApartmentTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Center(child: Text(widget.apartment.building)),
    );
  }
}

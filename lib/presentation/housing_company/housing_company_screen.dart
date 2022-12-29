import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/housing_company/components/poll_chart.dart';
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
import '../events/event_screen.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import '../announcement/announcement_item.dart';
import '../message/message_screen.dart';
import '../polls/poll_screen.dart';
import '../shared/app_gallery.dart';
import '../shared/conversation_item.dart';
import '../shared/setting_button.dart';
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
      child: BlocConsumer<HousingCompanyCubit, HousingCompanyState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.housingCompany?.ui != null) {
              BlocProvider.of<SettingCubit>(context)
                  .updateUIFromCompany(state.housingCompany?.ui);
            }
            return Scaffold(
                body: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
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
                  pinned: true,
                  title: Text(
                    state.housingCompany?.name ?? 'Housing company',
                  ),
                  forceElevated: true,
                  flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: state.housingCompany?.coverImageUrl ?? '',
                    errorWidget: (context, url, error) => const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: AppLottieAnimation(
                        loadingResource: 'apartment',
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                const SliverToBoxAdapter(
                    child: FullWidthTitle(
                  title: 'Document',
                )),
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
                          context.push(
                              '${GoRouter.of(context).location}/$documentListScreenPath');
                        },
                        child: const Text('More'))),
                SliverToBoxAdapter(
                  child: FullWidthTitle(
                    title: 'Polls',
                    action: TextButton(
                      onPressed: () {
                        context.push(
                            '${GoRouter.of(context).location}/$pollScreenPath');
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final poll = state.ongoingPollList?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: poll != null
                          ? Column(
                              children: [
                                SettingButton(
                                  onPressed: () {
                                    context.push(
                                        '${GoRouter.of(context).location}/$pollScreenPath/${poll.id}');
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
                  },
                  childCount: state.ongoingPollList?.length ?? 0,
                )),
                SliverToBoxAdapter(
                    child: TextButton(
                        onPressed: () {}, child: const Text('More'))),
                SliverToBoxAdapter(
                  child: FullWidthTitle(
                    title: 'Events',
                    action: TextButton(
                      onPressed: () {
                        context.push(
                            '${GoRouter.of(context).location}/$eventScreenPath');
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SfCalendar(
                    firstDayOfWeek: 1,
                    view: CalendarView.week,
                    onTap: (calendarTapDetails) {
                      context.push(
                          '${GoRouter.of(context).location}/$eventScreenPath/${(calendarTapDetails.appointments?[0] as Event).id}');
                    },
                    dataSource: EventDataSource(state.ongoingEventList ?? []),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final event = state.ongoingEventList?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: event != null
                          ? SettingButton(
                              onPressed: () {
                                context.push(
                                    '${GoRouter.of(context).location}/$eventScreenPath/${event.id}');
                              },
                              label: Text(
                                state.ongoingEventList?[index].name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                  childCount: state.ongoingEventList?.length ?? 0,
                )),
                const SliverToBoxAdapter(
                    child: FullWidthTitle(
                  title: 'Fault report',
                )),
                const SliverToBoxAdapter(
                    child: FullWidthTitle(
                  title: 'Renovation requests',
                )),
                const SliverToBoxAdapter(
                    child: FullWidthTitle(
                  title: 'Company acoounting',
                )),
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

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(
        (appointments![index] as Event).startTime);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(
        (appointments![index] as Event).endTime);
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Event).name;
  }
}

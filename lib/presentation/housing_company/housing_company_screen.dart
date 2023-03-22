import 'package:cached_network_image/cached_network_image.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import '../announcement/announcement_item.dart';
import '../announcement/announcement_screen.dart';
import '../events/event_screen.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import 'components/event_data_source.dart';
import 'components/generate_feature_card_list.dart';

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
    cubit = serviceLocator<HousingCompanyCubit>()
      ..init(widget.housingCompanyId);
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HousingCompanyCubit>(
      create: (_) => cubit,
      child: BlocConsumer<HousingCompanyCubit, HousingCompanyState>(
          listener: (context, state) {},
          builder: (context, state) {
            final widgetList = createFeatureWidgetList(context, state);
            if (state.housingCompany?.ui != null) {
              BlocProvider.of<SettingCubit>(context)
                  .updateUIFromCompany(state.housingCompany?.ui);
            }
            return Scaffold(
                body: RefreshIndicator(
              onRefresh: () => cubit.init(widget.housingCompanyId),
              child: CustomScrollView(slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  centerTitle: false,
                  elevation: 8,
                  forceElevated: true,
                  pinned: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)),
                        color: Theme.of(context).colorScheme.onPrimary,
                        onPressed: state.housingCompany?.isUserManager == true
                            ? () {
                                context
                                    .pushFromCurrentLocation(manageScreenPath);
                              }
                            : null,
                        icon: const Icon(Icons.manage_accounts),
                      ),
                    )
                  ],
                  title: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.background),
                    child: FittedBox(
                      child: Text(
                        state.housingCompany?.name ?? 'Housing company',
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: state.housingCompany?.coverImageUrl ?? '',
                          errorWidget: (context, url, error) => Image.asset(
                                'assets/apartment_background.png',
                                fit: BoxFit.fill,
                              ))),
                ),
                const SliverToBoxAdapter(
                  child: AnnouncementBox(),
                ),
                const SliverToBoxAdapter(
                  child: CalendarBox(),
                ),
                SliverGrid.builder(
                    itemCount: widgetList.length,
                    gridDelegate: const ResponsiveGridDelegate(
                        minCrossAxisExtent: 200,
                        maxCrossAxisExtent: 500,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: widgetList[index],
                        ),
                      );
                    }),
              ]),
            ));
          }),
    );
  }
}

class CalendarBox extends StatelessWidget {
  const CalendarBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
        builder: (context, state) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveValue(
              context,
              defaultValue: 16.0,
              valueWhen: const [
                Condition.smallerThan(
                  name: TABLET,
                  value: 8.0,
                ),
                Condition.largerThan(
                  name: TABLET,
                  value: 16.0,
                )
              ],
            ).value ??
            16.0),
        child: AspectRatio(
          aspectRatio: ResponsiveValue(
                context,
                defaultValue: 2.5,
                valueWhen: const [
                  Condition.smallerThan(
                    name: TABLET,
                    value: 1.0,
                  ),
                  Condition.largerThan(
                    name: TABLET,
                    value: 2.5,
                  )
                ],
              ).value ??
              2,
          child: Card(
            child: Column(
              children: [
                FullWidthTitle(
                  title: 'Events',
                  action: TextButton(
                    onPressed: state.housingCompany?.isUserManager == true
                        ? () {
                            context.pushFromCurrentLocation(eventScreenPath);
                          }
                        : null,
                    child: const Text('Add'),
                  ),
                ),
                Expanded(
                  child: SfCalendar(
                    timeSlotViewSettings: const TimeSlotViewSettings(
                        timeIntervalHeight: 30, startHour: 7, endHour: 22),
                    firstDayOfWeek: 1,
                    view: ResponsiveValue<CalendarView>(context,
                        defaultValue: CalendarView.month,
                        valueWhen: [
                          const Condition.smallerThan(
                              name: TABLET, value: CalendarView.day),
                          const Condition.largerThan(
                              name: MOBILE, value: CalendarView.month)
                        ]).value!,
                    onTap: (calendarTapDetails) {
                      if (calendarTapDetails.appointments?[0] != null) {
                        context.pushFromCurrentLocation(
                          '$eventScreenPath/${(calendarTapDetails.appointments?[0] as Event).id}',
                        );
                      } else if (state.housingCompany?.isUserManager == true) {
                        context.pushFromCurrentLocation(
                          '$eventScreenPath?initialStartTime=${calendarTapDetails.date?.millisecondsSinceEpoch}',
                        );
                      }
                    },
                    onSelectionChanged: (onSelectionChanged) {},
                    dataSource: EventDataSource(state.ongoingEventList ?? []),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AnnouncementBox extends StatelessWidget {
  const AnnouncementBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
        builder: (context, state) {
      return Column(
        children: [
          const FullWidthTitle(
            title: 'Announcements',
          ),
          SizedBox(
            width: double.infinity,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.announcementList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final announcement = state.announcementList?[index];
                    return announcement != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnnouncementItem(
                              companyId: state.housingCompany?.id ?? '',
                              announcement: announcement,
                            ))
                        : const SizedBox.shrink();
                  }),
            ),
          ),
          TextButton(
              onPressed: () {
                context.pushFromCurrentLocation(announcementPath);
              },
              child: const Text('More'))
        ],
      );
    });
  }
}

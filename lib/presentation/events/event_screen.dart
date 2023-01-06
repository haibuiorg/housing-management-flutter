import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/notification_service.dart';
import 'package:priorli/presentation/events/event_screen_cubit.dart';
import 'package:priorli/presentation/events/event_screen_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';

import '../../go_router_navigation.dart';
import 'event_creation_form.dart';
import 'event_detail.dart';

const eventScreenPath = 'events';

class EventScreen extends StatefulWidget {
  const EventScreen(
      {super.key,
      required this.companyId,
      this.eventId,
      this.initialStartTime,
      this.initialEndTime});
  final String? eventId;
  final String companyId;

  final String? initialStartTime;
  final String? initialEndTime;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final EventScreenCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    if (widget.eventId != null && widget.eventId?.isNotEmpty == true) {
      await _cubit.init(eventId: widget.eventId, companyId: widget.companyId);
      return;
    }
    await _cubit.init(eventId: null, companyId: widget.companyId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventScreenCubit>(
        create: (_) => _cubit,
        child: BlocBuilder<EventScreenCubit, EventScreenState>(
            builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.isInitializing
                  ? 'Loading'
                  : state.event != null
                      ? 'Event detail'
                      : 'Create an event'),
            ),
            bottomSheet: state.event == null
                ? null
                : BottomSheet(
                    onClosing: () {},
                    builder: (_) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).padding.bottom),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ChoiceChip(
                                labelPadding: const EdgeInsets.all(2.0),
                                label: const Text('Accepted'),
                                selected: (state.event?.accepted ?? [])
                                    .contains(state.userId),
                                onSelected: (value) {
                                  _cubit.responseToEvent(true).then((event) =>
                                      handleEventNotification(event!));
                                },
                                elevation: 1,
                              ),
                              ChoiceChip(
                                labelPadding: const EdgeInsets.all(2.0),
                                label: const Text('Maybe'),
                                selected: !(state.event?.accepted ?? [])
                                        .contains(state.userId) &&
                                    !(state.event?.declined ?? [])
                                        .contains(state.userId),
                                onSelected: (value) {
                                  _cubit.responseToEvent(null).then((event) =>
                                      handleEventNotification(event!));
                                },
                                elevation: 1,
                              ),
                              ChoiceChip(
                                labelPadding: const EdgeInsets.all(2.0),
                                label: const Text('Decline'),
                                selected: (state.event?.declined ?? [])
                                    .contains(state.userId),
                                onSelected: (value) {
                                  _cubit.responseToEvent(false).then((event) =>
                                      handleEventNotification(event!));
                                },
                                elevation: 1,
                              )
                            ]),
                      );
                    }),
            body: state.isInitializing
                ? const AppLottieAnimation(
                    loadingResource: 'checking_calendar',
                  )
                : state.event != null
                    ? EventDetail(
                        companyId: state.companyId ?? '',
                        event: state.event!,
                        onSubmit: (
                            {required description,
                            required endTime,
                            required name,
                            reminders,
                            repeat,
                            repeatUntil,
                            required startTime,
                            required type}) {
                          _cubit
                              .editEvent(
                                  description: description,
                                  endTime: endTime,
                                  name: name,
                                  reminders: reminders,
                                  repeat: repeat,
                                  repeatUntil: repeatUntil,
                                  startTime: startTime,
                                  type: type)
                              .then((value) {
                            if (value!.declined?.contains(state.userId) ==
                                false) handleEventNotification(value);
                          });
                        },
                        availableEventTypes: EventType.values,
                        onDelete: () {
                          _cubit
                              .deleteEvent(eventId: state.event?.id ?? '')
                              .then((value) async {
                            cancelEventNotification(value!).then((value) {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      housingCompanyScreenPathName));
                            });
                          });
                        },
                      )
                    : EventCreationForm(
                        inititalStartTime: widget.initialStartTime != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.initialStartTime!))
                            : null,
                        initialEndTime: widget.initialEndTime != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.initialEndTime!))
                            : null,
                        companyId: state.companyId ?? '',
                        onSubmit: (
                            {required description,
                            required endTime,
                            required invitees,
                            required name,
                            repeatUntil,
                            reminders,
                            repeat,
                            required startTime,
                            required type}) {
                          _cubit
                              .createEvent(
                                  name: name,
                                  description: description,
                                  startTime: startTime,
                                  endTime: endTime,
                                  type: type,
                                  repeat: repeat,
                                  reminders: reminders,
                                  repeatUntil: repeatUntil,
                                  invitees: invitees)
                              .then((event) => handleEventNotification(event!));
                        },
                        availableEventTypes: EventType.values,
                      ),
          );
        }));
  }
}

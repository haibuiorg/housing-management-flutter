import 'package:flutter/material.dart';

import '../../core/event/entities/event.dart';
import '../../core/event/entities/event_type.dart';
import '../../core/event/entities/reminder.dart';
import '../../core/event/entities/repeat.dart';
import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../guest_invitation/guest_invitation.dart';
import '../shared/custom_form_field.dart';
import '../shared/date_time_selector.dart';
import '../shared/full_width_pair_text.dart';
import '../shared/setting_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetail extends StatefulWidget {
  const EventDetail(
      {super.key,
      required this.event,
      required this.companyId,
      this.availableEventTypes,
      required this.onSubmit,
      required this.onDelete});
  final Event event;
  final String companyId;
  final Function() onDelete;

  final List<EventType>? availableEventTypes;
  final Function(
      {required String name,
      required String description,
      required int startTime,
      required int endTime,
      required EventType type,
      int? repeatUntil,
      List<int>? reminders,
      Repeat? repeat}) onSubmit;

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool _editable = false;

  late DateTime _startTime;
  late DateTime _endTime;
  late EventType _type;
  late Repeat? _repeat;
  late List<Reminder> _reminders;
  late DateTime? _repeatUntil;
  final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();

  _startEdit() {
    setState(() {
      _editable = !_editable;
    });
  }

  _saveEdit() {
    setState(() {
      _editable = !_editable;
    });
    widget.onSubmit(
        name: _nameController.text,
        description: _descriptionController.text,
        startTime: _startTime.millisecondsSinceEpoch,
        endTime: _endTime.millisecondsSinceEpoch,
        repeat: _repeat,
        type: _type,
        reminders: _reminders.map((e) => getReminderBeforeTime(e)).toList(),
        repeatUntil: _repeatUntil?.millisecondsSinceEpoch);
  }

  _clearEdit() {
    setState(() {
      _editable = !_editable;
      _init();
    });
  }

  _showRemoveEvent() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(AppLocalizations.of(context)!.remove_event_confirm),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancel)),
                OutlinedButton(
                    onPressed: () {
                      widget.onDelete();
                    },
                    child: Text(AppLocalizations.of(context)!.remove))
              ],
            ));
  }

  _init() {
    _repeatUntil = (widget.event.repeatUntil != null)
        ? DateTime.fromMillisecondsSinceEpoch(widget.event.repeatUntil!)
        : null;
    _reminders =
        widget.event.reminders?.map((e) => getTimeFromRemider(e)).toList() ??
            [];
    _startTime = DateTime.fromMillisecondsSinceEpoch(widget.event.startTime);
    _endTime = DateTime.fromMillisecondsSinceEpoch(widget.event.endTime);
    _type = widget.event.type;
    _repeat = widget.event.repeat;
    _descriptionController.text = widget.event.description;
    _nameController.text = widget.event.name;
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomFormField(
                      textEditingController: _nameController,
                      hintText: AppLocalizations.of(context)!.event_name,
                      helperText: AppLocalizations.of(context)!.event_name,
                      enabled: _editable,
                    ),
                    CustomFormField(
                      textEditingController: _descriptionController,
                      hintText: AppLocalizations.of(context)!.event_description,
                      helperText:
                          AppLocalizations.of(context)!.event_description,
                      enabled: _editable,
                    ),
                    _editable
                        ? SettingButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) => DateTimePicker(
                                  onConfirmTime: (dateTime) {
                                    setState(() {
                                      _startTime = dateTime;
                                    });
                                  },
                                ),
                              );
                            },
                            label: Text(AppLocalizations.of(context)!
                                .start_at_time(getFormattedDateTime(
                                    _startTime.millisecondsSinceEpoch))),
                          )
                        : FullWidthPairText(
                            label:
                                (AppLocalizations.of(context)!.start_at_title),
                            content: getFormattedDateTime(
                                _startTime.millisecondsSinceEpoch)),
                    _editable
                        ? SettingButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) => DateTimePicker(
                                  onConfirmTime: (dateTime) {
                                    setState(() {
                                      _endTime = dateTime;
                                    });
                                  },
                                ),
                              );
                            },
                            label: Text(AppLocalizations.of(context)!
                                .until_time(getFormattedDateTime(
                                    _endTime.millisecondsSinceEpoch))),
                          )
                        : FullWidthPairText(
                            label: AppLocalizations.of(context)!.until_title,
                            content: getFormattedDateTime(
                                _endTime.millisecondsSinceEpoch)),
                    _repeat != null
                        ? SettingButton(
                            label: Text(AppLocalizations.of(context)!
                                .repeat_until_time(getFormattedDateTime(
                                    _repeatUntil?.millisecondsSinceEpoch ??
                                        _endTime.millisecondsSinceEpoch))),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (builder) => DateTimePicker(
                                  onConfirmTime: (dateTime) {
                                    setState(() {
                                      _repeatUntil = dateTime;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      children: List.generate(EventType.values.length, (index) {
                        return ChoiceChip(
                          labelPadding: const EdgeInsets.all(2.0),
                          label: Text(EventType.values[index].name),
                          selected: _type == EventType.values[index],
                          onSelected: _editable
                              ? (value) {
                                  setState(() {
                                    _type = EventType.values[index];
                                  });
                                }
                              : null,
                          elevation: 1,
                        );
                      }),
                    ),
                    const Divider(),
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: List.generate(Repeat.values.length, (index) {
                        return ChoiceChip(
                          labelPadding: const EdgeInsets.all(2.0),
                          label: Text(Repeat.values[index].name),
                          selected: _repeat == Repeat.values[index],
                          onSelected: _editable
                              ? (value) {
                                  setState(() {
                                    _repeat = Repeat.values[index];
                                  });
                                }
                              : null,
                          elevation: 1,
                        );
                      }),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: List.generate(Reminder.values.length, (index) {
                        return ChoiceChip(
                          labelPadding: const EdgeInsets.all(2.0),
                          label: Text(Reminder.values[index].name),
                          selected:
                              _reminders.contains(Reminder.values[index]) ==
                                  true,
                          onSelected: _editable
                              ? (value) {
                                  if (Reminder.values[index] == Reminder.none) {
                                    if (value) {
                                      _reminders.clear();
                                    }
                                  } else {
                                    if (_reminders.contains(Reminder.none)) {
                                      _reminders.remove(Reminder.none);
                                    }
                                  }
                                  if (_reminders
                                      .contains(Reminder.values[index])) {
                                    setState(() {
                                      _reminders.remove(Reminder.values[index]);
                                    });
                                    return;
                                  }

                                  setState(() {
                                    _reminders.add(Reminder.values[index]);
                                  });
                                }
                              : null,
                          elevation: 1,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    OutlinedButton(
                        onPressed: _editable ? _saveEdit : _startEdit,
                        child: Text(_editable
                            ? AppLocalizations.of(context)!.save
                            : AppLocalizations.of(context)!.edit)),
                    _editable
                        ? TextButton(
                            onPressed: _clearEdit,
                            child: Text(AppLocalizations.of(context)!.clear))
                        : const SizedBox.shrink()
                  ],
                ),
              )
            ],
          ),
          SettingButton(
            label: Text(AppLocalizations.of(context)!.manage_participants),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) => GuestInvitation(
                  eventId: widget.event.id,
                  companyId: widget.companyId,
                  initialSelectedUser: widget.event.accepted,
                  onUserSelected: ({required List<User> userList}) {
                    Navigator.pop(builder, true);
                  },
                ),
              );
            },
          ),
          TextButton(
              onPressed: _showRemoveEvent,
              child: Text(AppLocalizations.of(context)!.remove_event))
        ]),
      ),
    );
  }
}

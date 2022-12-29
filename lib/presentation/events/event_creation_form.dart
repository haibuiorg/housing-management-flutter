import 'package:flutter/material.dart';
import 'package:priorli/core/event/entities/reminder.dart';

import '../../core/event/entities/event_type.dart';
import '../../core/event/entities/repeat.dart';
import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../housing_company_users/guest_invitation.dart';
import '../shared/custom_form_field.dart';
import '../shared/date_time_selector.dart';
import '../shared/setting_button.dart';

class EventCreationForm extends StatefulWidget {
  const EventCreationForm(
      {super.key,
      this.availableEventTypes,
      this.availableRepeatTypes,
      required this.onSubmit,
      required this.companyId});
  final String companyId;
  final List<EventType>? availableEventTypes;
  final List<Repeat>? availableRepeatTypes;
  final Function(
      {required String name,
      required String description,
      required int startTime,
      required int endTime,
      required EventType type,
      required List<String> invitees,
      List<int>? reminders,
      int? repeatUntil,
      Repeat? repeat}) onSubmit;
  @override
  State<EventCreationForm> createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  late DateTime _startTime;
  late DateTime _endTime;
  late EventType _type;
  late Repeat? _repeat;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late List<String> _invitees;
  late List<String> _displayName;
  late List<Reminder> _reminders;
  late DateTime? _repeatUntil;
  late bool _validated;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().add(const Duration(days: 1));
    _endTime = _startTime.add(const Duration(days: 1, hours: 1));
    _type = EventType.company;
    _repeat = null;
    _repeatUntil = null;
    _reminders = [];
    _descriptionController = TextEditingController();
    _nameController = TextEditingController();
    _invitees = [];
    _displayName = [];
    _validated = false;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  _checkValidation() {
    setState(() {
      _validated = !(_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _startTime.millisecondsSinceEpoch >= _endTime.millisecondsSinceEpoch);
    });
  }

  _submitInfo() {
    widget.onSubmit(
        name: _nameController.text,
        description: _descriptionController.text,
        startTime: _startTime.millisecondsSinceEpoch,
        endTime: _endTime.millisecondsSinceEpoch,
        repeat: _repeat,
        type: _type,
        reminders: _reminders
            .map((e) => getReminderBeforeTime(e))
            .where((element) => element > 0)
            .toList(),
        repeatUntil: _repeatUntil?.millisecondsSinceEpoch,
        invitees: _invitees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !_validated
          ? null
          : FloatingActionButton(
              onPressed: _submitInfo,
              child: const Icon(Icons.check_rounded),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomFormField(
              hintText: 'Event name',
              textEditingController: _nameController,
              onChanged: (value) {
                _checkValidation();
              },
            ),
            CustomFormField(
              hintText: 'Event description',
              textEditingController: _descriptionController,
              onChanged: (value) {
                _checkValidation();
              },
            ),
            SettingButton(
              label: Text(
                  'Start time ${getFormattedDateTime(_startTime.millisecondsSinceEpoch)}'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => DateTimePicker(
                    onConfirmTime: (dateTime) {
                      setState(() {
                        _startTime = dateTime;
                      });
                      _checkValidation();
                    },
                  ),
                );
              },
            ),
            SettingButton(
              label: Text(
                  'End time: ${getFormattedDateTime(_endTime.millisecondsSinceEpoch)}'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => DateTimePicker(
                    onConfirmTime: (dateTime) {
                      setState(() {
                        _endTime = dateTime;
                      });
                      _checkValidation();
                    },
                  ),
                );
              },
            ),
            _repeat != null
                ? SettingButton(
                    label: Text(
                        'Repeat until: ${getFormattedDateTime(_repeatUntil?.millisecondsSinceEpoch ?? _endTime.millisecondsSinceEpoch)}'),
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
            SettingButton(
              label: Text(
                  'Guests: ${_displayName.isEmpty ? 'None' : _displayName}'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => GuestInvitation(
                    companyId: widget.companyId,
                    initialSelectedUser: _invitees,
                    onUserSelected: ({required List<User> userList}) {
                      setState(() {
                        _invitees = userList.map((e) => e.userId).toList();
                        _displayName = userList
                            .map((e) => '${e.firstName} ${e.lastName}')
                            .toList();
                      });
                      Navigator.pop(context, true);
                    },
                  ),
                );
              },
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: List.generate(
                  widget.availableEventTypes?.length ?? EventType.values.length,
                  (index) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.all(2.0),
                  label: Text(EventType.values[index].name),
                  selected: _type == EventType.values[index],
                  onSelected: (value) {
                    setState(() {
                      _type = EventType.values[index];
                    });
                  },
                  elevation: 1,
                );
              }),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: List.generate(
                  widget.availableRepeatTypes?.length ?? Repeat.values.length,
                  (index) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.all(2.0),
                  label: Text(Repeat.values[index].name),
                  selected: _repeat == Repeat.values[index],
                  onSelected: (value) {
                    if (_repeat != Repeat.values[index]) {
                      setState(() {
                        _repeat = Repeat.values[index];
                      });
                      return;
                    }
                    setState(() {
                      _repeat = null;
                      _repeatUntil = null;
                    });
                  },
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
                  selected: _reminders.contains(Reminder.values[index]) == true,
                  onSelected: (value) {
                    if (Reminder.values[index] == Reminder.none) {
                      if (value) {
                        _reminders.clear();
                      }
                    } else {
                      if (_reminders.contains(Reminder.none)) {
                        _reminders.remove(Reminder.none);
                      }
                    }
                    if (_reminders.contains(Reminder.values[index])) {
                      setState(() {
                        _reminders.remove(Reminder.values[index]);
                      });
                      return;
                    }

                    setState(() {
                      _reminders.add(Reminder.values[index]);
                    });
                  },
                  elevation: 1,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

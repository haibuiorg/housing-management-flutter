import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {super.key, required this.onConfirmTime, this.initialDate});
  final Function(DateTime dateTime) onConfirmTime;
  final DateTime? initialDate;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDate;
  late TimeOfDay time;
  @override
  void initState() {
    selectedDate =
        widget.initialDate ?? DateTime.now().add(const Duration(days: 1));
    time = TimeOfDay.fromDateTime(selectedDate);
    time = time.replacing(hour: time.hour < 23 ? time.hour + 1 : 0, minute: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarDatePicker(
          initialDate: selectedDate,
          currentDate: null,
          firstDate: DateTime.now(),
          onDateChanged: (DateTime value) {
            selectedDate = value;
          },
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  _showTimePicker();
                },
                child: Text(
                  'At: ${time.format(context)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.tertiary),
                )),
            OutlinedButton(
                onPressed: () {
                  final dateFrom = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      time.hour,
                      time.minute);
                  widget.onConfirmTime(dateFrom);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.confirm_date_time))
          ],
        ),
      ],
    );
  }

  _showTimePicker() async {
    final newTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
      context: context,
      initialTime: time,
    );
    if (newTime == null) {
      return;
    }
    setState(() {
      time = newTime;
    });
  }
}

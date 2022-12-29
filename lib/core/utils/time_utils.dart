import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:priorli/core/event/entities/reminder.dart';

String getFormattedDateTime(int timeInMillis) {
  try {
    return DateFormat.jm()
        .add_Md()
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
  } catch (e) {
    debugPrint(e.toString());
  }
  return '';
}

String getFormattedDate(int timeInMillis) {
  try {
    return DateFormat.yMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
  } catch (e) {
    debugPrint(e.toString());
  }
  return '';
}

int getReminderBeforeTime(Reminder reminder) {
  if (reminder == Reminder.fifteenMinuteBefore) {
    return 900000;
  } else if (reminder == Reminder.thirtyMinuteBefore) {
    return 1800000;
  } else if (reminder == Reminder.oneHourBefore) {
    return 3600000;
  } else if (reminder == Reminder.oneDayBefore) {
    return 86400000;
  } else {
    return -1;
  }
}

Reminder getTimeFromRemider(int reminderTime) {
  if (reminderTime == 900000) {
    return Reminder.fifteenMinuteBefore;
  } else if (reminderTime == 1800000) {
    return Reminder.thirtyMinuteBefore;
  } else if (reminderTime == 3600000) {
    return Reminder.oneHourBefore;
  } else if (reminderTime == 86400000) {
    return Reminder.oneDayBefore;
  } else {
    return Reminder.none;
  }
}

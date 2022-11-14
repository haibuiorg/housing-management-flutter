import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String getFormattedDateTime(int timeInMillis) {
  try {
    return DateFormat.jm().add_Md().format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
  } catch (e) {
    debugPrint(e.toString());
  }
  return '';
}

String getFormattedDate(int timeInMillis) {
  try {
    return DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
  } catch (e) {
    debugPrint(e.toString());
  }
  return '';
}
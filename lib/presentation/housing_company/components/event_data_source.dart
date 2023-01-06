import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/event/entities/event.dart';

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

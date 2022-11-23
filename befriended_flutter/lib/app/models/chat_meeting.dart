import 'package:syncfusion_flutter_calendar/calendar.dart';

///A model for a scheduled chat to render in the calendar.
class ChatMeeting {
  ChatMeeting(this.chattingWith, this.year, this.month, this.day, this.hour,
      this.minute,);
  String chattingWith;
  int year;
  int month;
  int day;
  int hour;
  int minute;
}

///An object that sets appointment data for the calendar.
class ChatMeetingDataSource extends CalendarDataSource {
  ChatMeetingDataSource(List<ChatMeeting> dataSource) {
    //All the appointments to render in the calendar.
    appointments = dataSource;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List  source) {
    appointments = source;
  }
}

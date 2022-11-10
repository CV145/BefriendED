import 'package:intl/intl.dart';

String displayDate(DateTime dateTime) {
  return DateFormat('dd MMM yyyy').format(dateTime);
}

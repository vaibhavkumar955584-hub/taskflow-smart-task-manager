import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static final DateFormat _friendly = DateFormat('EEE, MMM d');

  static String friendly(DateTime date) => _friendly.format(date);
}

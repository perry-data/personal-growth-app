import 'package:intl/intl.dart';

class AppDateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  /// Returns the current date as a string in YYYY-MM-DD format.
  static String get today => _dateFormat.format(DateTime.now());

  /// Formats a DateTime to YYYY-MM-DD string.
  static String format(DateTime date) => _dateFormat.format(date);

  /// Parses a YYYY-MM-DD string to DateTime.
  static DateTime parse(String date) => _dateFormat.parse(date);
}

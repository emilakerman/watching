import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String formattedDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formattedTime() {
    return DateFormat('HH:mm').format(this);
  }
}

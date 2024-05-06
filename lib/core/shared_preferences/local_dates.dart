import 'package:shared_preferences/shared_preferences.dart';

class LocallyStoredDates {
  final String key = 'dates';
  Future<void> addDateTime(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDates = prefs.getStringList(key) ?? [];
    encodedDates.add(date);
    await prefs.setStringList(key, encodedDates);
  }

  Future<bool> isDateTimeStored(String datetime) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDates = prefs.getStringList(key);
    if (encodedDates != null) {
      final dates = encodedDates.map((encodedDate) => encodedDate).toList();
      return dates.contains(datetime);
    }
    return false;
  }
}

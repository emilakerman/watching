import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocallyStoredData {
  final String key = 'shows';

  Future<void> saveData({required Map<String, dynamic> show}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> savedShows = prefs.getStringList(key) ?? [];

    savedShows.add(jsonEncode(show));
    await prefs.setStringList(key, savedShows);
  }

  Future<List<dynamic>> readData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedShows = prefs.getStringList(key) ?? [];

    final List<Map<String, dynamic>> shows = savedShows
        .map((show) => jsonDecode(show) as Map<String, dynamic>)
        .toList();

    return shows;
  }

  Future<void> deleteData({required Map<String, dynamic> show}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedShows = prefs.getStringList(key) ?? [];

    final String showJson = jsonEncode(show);

    savedShows.removeWhere((savedShow) {
      return savedShow == showJson;
    });

    await prefs.setStringList(key, savedShows);
  }
}

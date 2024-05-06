import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching/src/src.dart';

class LocallyStoredShows {
  final String key = 'shows';
  Future<void> addShows(List<Show> shows) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedShows = shows.map((show) => show.toJson()).toList();
    await prefs.setStringList(
      key,
      encodedShows.map((show) => json.encode(show)).toList(),
    );
  }

  Future<List<Show>> readShows() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedShows = prefs.getStringList(key);
    if (encodedShows != null) {
      final shows = encodedShows
          .map((encodedShow) =>
              Show.fromJson(json.decode(encodedShow) as Map<String, Object?>))
          .toList();
      return shows;
    }
    return [];
  }
}

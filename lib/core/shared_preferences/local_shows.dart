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

  // Enhanced method to append shows only if they don't exist
  Future<void> appendShows(List<Show> newShows) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Show> currentShows = await readShows(); // Read existing shows

    // Create a set of existing show names for quick lookup
    final existingShows =
        Set<String>.from(currentShows.map((show) => show.name));

    // Filter out shows that already exist
    final List<Show> showsToAdd =
        newShows.where((show) => !existingShows.contains(show.name)).toList();
    if (showsToAdd.isNotEmpty) {
      currentShows.addAll(showsToAdd); // Append new shows

      // Convert all shows to JSON and save them
      final encodedShows =
          currentShows.map((show) => json.encode(show.toJson())).toList();
      await prefs.setStringList(key, encodedShows);
    }
  }

  Future<List<Show>> readShows() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedShows = prefs.getStringList(key);
    if (encodedShows != null) {
      final shows = encodedShows
          .map(
            (encodedShow) =>
                Show.fromJson(json.decode(encodedShow) as Map<String, Object?>),
          )
          .toList();
      return shows;
    }
    return [];
  }
}

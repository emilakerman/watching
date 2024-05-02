import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

class SupabaseServices {
  SupabaseServices({
    required SupabaseRepository supabaseRepository,
  }) : _supabaseRepository = supabaseRepository;

  Future<List<int>> getAllFavorites({required int userId}) async {
    final List<int> favoriteShows = [];
    final jsonResponse =
        await _supabaseRepository.fetchFavorites(userId: userId);
    jsonResponse?.forEach((element) {
      final shows = element['shows'] as List<dynamic>;
      for (final show in shows) {
        if (show['favorite'] == true) {
          favoriteShows.add(show['showid'] as int);
        }
      }
    });
    Logger().d('Favorite Show ids: $favoriteShows');
    return favoriteShows;
  }

  final SupabaseRepository _supabaseRepository;
}

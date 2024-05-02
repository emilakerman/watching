import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

class ShowService {
  ShowService({
    required TvMazeRepository tvMazeRepository,
  }) : _tvMazeRepository = tvMazeRepository;

  Future<List<Show>> getAllShows() async {
    final jsonResponse = await _tvMazeRepository.getAllShows();
    final shows = (jsonResponse as List)
        .map((show) => Show.fromJson(show as Map<String, dynamic>))
        .toList();
    return shows;
  }

  Future<List<Show>> getFavoritesByUserId({required int userId}) async {
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    final List<int> favoriteIds =
        await supabaseServices.getAllFavorites(userId: userId);
    final List<Show> favoriteShows = [];
    for (final int favoriteId in favoriteIds) {
      final jsonResponse =
          await _tvMazeRepository.getShowById(showId: favoriteId);
      final show = Show.fromJson(jsonResponse as Map<String, dynamic>);
      favoriteShows.add(show);
    }
    return favoriteShows;
  }

  final TvMazeRepository _tvMazeRepository;
}

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

  Future<List<Show>> getAllCompleted({required int userId}) async {
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    final List<int> completedIds =
        await supabaseServices.getAllCompleted(userId: userId);
    final List<Show> completedShows = [];
    for (final int completedId in completedIds) {
      final jsonResponse =
          await _tvMazeRepository.getShowById(showId: completedId);
      final show = Show.fromJson(jsonResponse as Map<String, dynamic>);
      completedShows.add(show);
    }
    return completedShows;
  }

  Future<List<Show>> getAllWatching({required int userId}) async {
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    final List<int> watchingIds =
        await supabaseServices.getAllWatching(userId: userId);
    final List<Show> watchingShows = [];
    for (final int watchingId in watchingIds) {
      final jsonResponse =
          await _tvMazeRepository.getShowById(showId: watchingId);
      final show = Show.fromJson(jsonResponse as Map<String, dynamic>);
      watchingShows.add(show);
    }
    return watchingShows;
  }

  Future<List<Show>> getAllPlanToWatch({required int userId}) async {
    final SupabaseServices supabaseServices = SupabaseServices(
      supabaseRepository: SupabaseRepository(),
    );
    final List<int> planToWatchIds =
        await supabaseServices.getAllPlanToWatch(userId: userId);
    final List<Show> planToWatchShows = [];
    for (final int planToWatchId in planToWatchIds) {
      final jsonResponse =
          await _tvMazeRepository.getShowById(showId: planToWatchId);
      final show = Show.fromJson(jsonResponse as Map<String, dynamic>);
      planToWatchShows.add(show);
    }
    return planToWatchShows;
  }

  final TvMazeRepository _tvMazeRepository;
}

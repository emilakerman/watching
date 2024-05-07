import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';

class SupabaseServices {
  SupabaseServices({
    required SupabaseRepository supabaseRepository,
  }) : _supabaseRepository = supabaseRepository;

  Future<void> addNewShow({
    required int userId,
    required int showid,
    required String showStatus,
  }) async {
    try {
      await _supabaseRepository.addNewShow(
        userId: userId,
        showid: showid,
        showStatus: showStatus,
      );
    } catch (error) {
      Logger().d('Error adding new show: $error');
    }
  }

  Future<List<int>> getAllFavorites({required int userId}) async {
    final List<int> favoriteShows = [];
    final jsonResponse =
        await _supabaseRepository.fetchShowsByUserid(userId: userId);
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

  Future<List<int>> getAllCompleted({required int userId}) async {
    final List<int> completedShows = [];
    final jsonResponse =
        await _supabaseRepository.fetchShowsByUserid(userId: userId);
    jsonResponse?.forEach((element) {
      final shows = element['shows'] as List<dynamic>;
      for (final show in shows) {
        if (show['status'] == 'completed') {
          completedShows.add(show['showid'] as int);
        }
      }
    });
    Logger().d('Completed Show ids: $completedShows');
    return completedShows;
  }

  Future<List<int>> getAllWatching({required int userId}) async {
    final List<int> watchingShows = [];
    final jsonResponse =
        await _supabaseRepository.fetchShowsByUserid(userId: userId);
    jsonResponse?.forEach((element) {
      final shows = element['shows'] as List<dynamic>;
      for (final show in shows) {
        if (show['status'] == 'watching') {
          watchingShows.add(show['showid'] as int);
        }
      }
    });
    Logger().d('Watching Show ids: $watchingShows');
    return watchingShows;
  }

  Future<List<int>> getAllPlanToWatch({required int userId}) async {
    final List<int> planToWatchShows = [];
    final jsonResponse =
        await _supabaseRepository.fetchShowsByUserid(userId: userId);
    jsonResponse?.forEach((element) {
      final shows = element['shows'] as List<dynamic>;
      for (final show in shows) {
        if (show['status'] == 'plan-to-watch') {
          planToWatchShows.add(show['showid'] as int);
        }
      }
    });
    Logger().d('Watching Show ids: $planToWatchShows');
    return planToWatchShows;
  }

  Future<void> removeShow({required int userId, required int showid}) async {
    try {
      await _supabaseRepository.removeShow(userId: userId, showid: showid);
    } catch (error) {
      Logger().d('Error removing show: $error');
    }
  }

  final SupabaseRepository _supabaseRepository;
}

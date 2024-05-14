import 'package:logger/logger.dart';
import 'package:watching/src/src.dart';
import 'package:watching/utils/utils.dart';

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

  Future<List<int>> getAllFeaturedShows() async {
    final List<int> featuredShows = [];
    final jsonResponse = await _supabaseRepository.fetchFeaturedShows();
    jsonResponse?.forEach((element) {
      final shows = element['shows'] as List<dynamic>;
      for (final show in shows) {
        featuredShows.add(show['id'] as int);
      }
    });
    Logger().d('Featured Show ids: $featuredShows');
    return featuredShows;
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

  /// -- Combined Public Users with their completed shows and nicknames For the Leaderboard Feature --
  Future<List<CompletedUser>> fetchAllPublicUsers() async {
    final Future<List<dynamic>?> users =
        _supabaseRepository.fetchAllPublicUsers();
    final List<CompletedUser> completedUsers = [];
    final List<dynamic>? userList = await users;
    if (userList != null) {
      for (final user in userList) {
        final int userId = user as int;
        Logger().d('User id: $userId');
        final List<int> completedShows = await getAllCompleted(userId: userId);
        final String nickName = await _supabaseRepository
            .checkUserSettingsNicknameInSupabase(userId: userId);
        completedUsers.add(
          CompletedUser(
            userId: userId,
            completedShows: completedShows,
            nickname: nickName,
            color: stringToColour(nickName),
          ),
        );
      }
    }
    return completedUsers;
  }

  // -- For Settings Cubit -- //
  Future<List<Settings>> fetchAllSettings() async {
    final List<Settings> settings = [];
    final List<Map<String, dynamic>>? settingsList =
        await _supabaseRepository.fetchAllSettings();
    if (settingsList != null) {
      for (final setting in settingsList) {
        settings.add(
          Settings(
            userId: setting['id'] as int,
            isPublic: setting['isPublic'] as bool,
            nickname: setting['nickname'] as String,
          ),
        );
      }
    }
    return settings;
  }

  Future<void> updateSettingsRowInSupabase({
    required int userId,
    required bool isPublic,
    required String nickName,
  }) async {
    try {
      await _supabaseRepository.updateSettingsRowInSupabase(
        userId: userId,
        isPublic: isPublic,
        nickName: nickName,
      );
      Logger().d('Settings updated in Supabase with isPublic: $isPublic');
    } catch (error) {
      Logger().d('Error updating settings in supabase: $error');
    }
  }

  Future<void> toggleFavoriteShow({
    required int userId,
    required int showid,
    required bool isFavorite,
  }) async {
    try {
      await _supabaseRepository.toggleFavoriteShow(
        userId: userId,
        showid: showid,
        isFavorite: isFavorite,
      );
    } catch (error) {
      Logger().d('Error toggling favorite show: $error');
    }
  }

  final SupabaseRepository _supabaseRepository;
}

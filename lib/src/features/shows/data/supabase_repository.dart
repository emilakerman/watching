import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> toggleFavoriteShow({
    required int userId,
    required int showid,
    required bool isFavorite,
  }) async {
    try {
      final show = await supabase
          .from('Shows')
          .select('shows')
          .eq('userId', userId)
          .single();

      show['shows'].asMap().forEach((index, value) {
        if (value['showid'] == showid) {
          show['shows'][index]['favorite'] = isFavorite;
        }
      });
      await supabase.from('Shows').update(show).eq('userId', userId);
      Logger().d('Show favorite toggled in Supabase');
    } catch (error) {
      Logger().d('Error toggling show favorite in supabase: $error');
    }
  }

  Future<void> removeShow({
    required int userId,
    required int showid,
  }) async {
    try {
      final show = await supabase
          .from('Shows')
          .select('shows')
          .eq('userId', userId)
          .single();

      show['shows'].removeWhere((element) => element['showid'] == showid);
      await supabase.from('Shows').update(show).eq('userId', userId);
      Logger().d('Show removed from Supabase');
    } catch (error) {
      Logger().d('Error removing show from supabase: $error');
    }
  }

  Future<void> addNewShow({
    required int userId,
    required int showid,
    required String showStatus,
  }) async {
    bool showExists = false;
    try {
      final show = await supabase
          .from('Shows')
          .select('shows')
          .eq('userId', userId)
          .single();

      show['shows'].asMap().forEach((index, value) {
        if (value['showid'] == showid) {
          showExists = true;
        }
      });

      if (!showExists) {
        show['shows'].add({
          'showid': showid,
          'status': showStatus,
          'favorite': false,
        });
      } else {
        Logger().d('Show already exists in Supabase');
        if (show['status'] == showStatus) {
          Logger().d('Not proceeding with publishing or updating.');
          return;
        } else if (show['status'] != showStatus) {
          await updateStatusOfShow(
            userId: userId,
            showid: showid,
            showStatus: showStatus,
          );
          Logger().d('Show status updated in Supabase to $showStatus.');
          return;
        }
      }

      await supabase.from('Shows').update(show).eq('userId', userId);
      Logger().d('New show added to Supabase');
    } catch (error) {
      Logger().d('Error adding new show to Supabase: $error');
    }
  }

  Future<void> updateStatusOfShow({
    required int userId,
    required int showid,
    required String showStatus,
  }) async {
    try {
      final show = await supabase
          .from('Shows')
          .select('shows')
          .eq('userId', userId)
          .single();

      show['shows'].asMap().forEach((index, value) {
        if (value['showid'] == showid) {
          show['shows'][index]['status'] = showStatus;
        }
      });
      await supabase.from('Shows').update(show).eq('userId', userId);
      Logger().d('Show status updated in Supabase');
    } catch (error) {
      Logger().d('Error updating show status in supabase: $error');
    }
  }

  Future<void> createUserRowInSupaBase({required int userId}) async {
    try {
      await supabase.from('Users').insert(
        [
          {'userId': userId},
        ],
      );
      await supabase.from('Shows').insert(
        [
          {
            'userId': userId,
            'shows': [{}],
          },
        ],
      );
      Logger().d('User created in Supabase');
    } catch (error) {
      Logger().d('Error creating user in supabase: $error');
    }
  }

  Future<bool> checkIfUserExistsInSupabase({required int userId}) async {
    try {
      final response =
          await supabase.from('Users').select().eq('userId', userId);
      if (response.isNotEmpty) {
        Logger().d('User exists in Supabase: $response');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Logger().d('User does not exist in supabase: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchShowsByUserid({
    required int userId,
  }) async {
    try {
      Logger().d('Fetching shows by userid...');
      return await supabase.from('Shows').select().eq('userId', userId);
    } catch (error) {
      Logger().d('Error fetching shows by userid: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchFeaturedShows() async {
    try {
      Logger().d('Fetching featured shows...');
      return await supabase.from('Featured').select().eq('id', 1);
    } catch (error) {
      Logger().d('Error fetching featured shows: $error');
      return null;
    }
  }

  Future<void> updateSettingsRowInSupabase({
    required int userId,
    required bool isPublic,
    required String nickName,
  }) async {
    try {
      final settings = await supabase
          .from('Settings')
          .select('isPublic')
          .eq('id', userId)
          .single();

      settings['isPublic'] = isPublic;
      settings['nickname'] = nickName;
      await supabase.from('Settings').update(settings).eq('id', userId);
      Logger().d(
          'Settings updated in Supabase with isPublic: $isPublic and nickname: $nickName');
    } catch (error) {
      Logger().d('Error updating settings in supabase: $error');
    }
  }

  Future<void> createSettingsRowInSupabase({
    required int userId,
    required bool isPublic,
  }) async {
    try {
      await supabase.from('Settings').insert(
        [
          {
            'id': userId,
            'isPublic': isPublic,
          },
        ],
      );
      Logger().d('Settings added it Supabase with isPublic: $isPublic');
    } catch (error) {
      Logger().d('Error creating settings in supabase: $error');
    }
  }

  Future<bool> checkUserSettingsInSupabase({
    required int userId,
  }) async {
    try {
      final response =
          await supabase.from('Settings').select().eq('id', userId);
      Logger().d('User has settings in Supabase: $response');
      final settings = await supabase
          .from('Settings')
          .select('isPublic')
          .eq('id', userId)
          .single();
      return settings['isPublic'] as bool;
    } catch (error) {
      Logger().d('User does not have settings in supabase: $error');
      Logger().d('Creating settings row in Supabase...');
      await createSettingsRowInSupabase(userId: userId, isPublic: false);
      Logger().d('Created settings row in supabase!');
      return false;
    }
  }

  Future<String> checkUserSettingsNicknameInSupabase({
    required int userId,
  }) async {
    try {
      final response =
          await supabase.from('Settings').select().eq('id', userId);
      Logger().d('User has settings in Supabase: $response');
      final settings = await supabase
          .from('Settings')
          .select('nickname')
          .eq('id', userId)
          .single();
      return settings['nickname'] as String;
    } catch (error) {
      Logger().d('User does not have settings in supabase: $error');
      Logger().d('Creating settings row in Supabase...');
      await createSettingsRowInSupabase(userId: userId, isPublic: false);
      Logger().d('Created settings row in supabase!');
      return '';
    }
  }

  /// -- Fetches Public Users For the Leaderboard Feature --
  Future<List<dynamic>?> fetchAllPublicUsers() async {
    try {
      final response = await supabase.from('Settings').select().eq(
            'isPublic',
            true,
          );
      final ids = response.map((user) => user['id']).toList();
      Logger().d('Users ids with public settings: $ids');
      return ids;
    } catch (error) {
      Logger().d('Error fetching users with public settings: $error');
      return null;
    }
  }
}

import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> createUserRowInSupaBase({required int userId}) async {
    try {
      await supabase.from('Users').insert(
        [
          {'userId': userId},
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
      Logger().d('User exists in Supabase: $response');
      return true;
    } catch (error) {
      Logger().d('User does not exist in supabase: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchFavorites({
    required int userId,
  }) async {
    try {
      Logger().d('Fetching favorites...');
      return await supabase.from('Shows').select().eq('userId', userId);
    } catch (error) {
      Logger().d('Error fetching favorites: $error');
      return null;
    }
  }
}

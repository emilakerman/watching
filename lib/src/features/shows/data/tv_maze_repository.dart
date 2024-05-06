import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/web.dart';
import 'package:watching/src/src.dart';

class TvMazeRepository {
  TvMazeRepository() {
    _client = 'https://api.tvmaze.com/';
  }
  final FirebaseAuthRepository _firebaseAuthRepository =
      FirebaseAuthRepository();

  Future<dynamic> getShowByName({required String showName}) async {
    if (!_firebaseAuthRepository.isAuthenticated()) {
      Logger().d('User is not authenticated');
      return '';
    }
    final String url = '${_client}search/shows?q=$showName';
    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Logger().d('Failed to fetch shows by name');
      throw Exception('Failed to fetch shows by name');
    }
  }

  Future<dynamic> getShowById({required int showId}) async {
    final String url = '${_client}shows/$showId';
    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Logger().d('Failed to fetch show by id');
      throw Exception('Failed to fetch show by id');
    }
  }

  Future<dynamic> getAllShows() async {
    final String url = '${_client}shows';
    final Response response = await http.get(Uri.parse(url));
    Logger().d('Fetching shows....');
    if (response.statusCode != 200) {
      Logger().d('Failed to fetch shows');
      return [];
    } else {
      Logger().d('Fetched shows successfully!');
      return json.decode(response.body);
    }
  }

  late final String _client;
}

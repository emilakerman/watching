import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/web.dart';

class TvMazeRepository {
  TvMazeRepository({required String client}) {
    client = 'https://api.tvmaze.com/';
  }

  Future<String> getShowByName({required String showName}) async {
    final String url = '${client}singlesearch/shows?q=$showName';
    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final String show = response.body;
      return show;
    } else {
      Logger().d('Failed to fetch shows by genre');
      throw Exception('Failed to fetch shows by genre');
    }
  }

  Future<dynamic> getAllShows() async {
    final String url = '${client}shows';
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

  late final String client;
}

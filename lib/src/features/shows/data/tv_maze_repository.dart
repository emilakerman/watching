import 'dart:convert';
import 'package:http/http.dart' as http;

class TvMazeRepository {
  TvMazeRepository();

  Future<String> getShowByName({required String showName}) async {
    final url = 'https://api.tvmaze.com/singlesearch/shows?q=$showName';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final show = response.body;
      return show;
    } else {
      throw Exception('Failed to fetch series');
    }
  }

  Future<List<dynamic>> getAllShows() async {
    const url = 'https://api.tvmaze.com/shows';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch series');
    }
  }
}

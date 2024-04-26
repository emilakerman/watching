import 'dart:collection';
import 'package:watching/src/src.dart';

class ShowService {
  ShowService({
    required TvMazeRepository tvMazeRepository,
  }) : _tvMazeRepository = tvMazeRepository;

  Future<List<Show>> getAllShows() async {
    final jsonResponse = await _tvMazeRepository.getAllShows();
    return jsonResponse.map((json) => Show.fromJsonShow(json)).toList();

    // final shows = jsonResponse.value.map(Show.fromJsonShow).toList();
  }

  final TvMazeRepository _tvMazeRepository;
}

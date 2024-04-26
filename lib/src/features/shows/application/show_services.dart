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

  final TvMazeRepository _tvMazeRepository;
}

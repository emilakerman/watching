import 'package:watching/src/src.dart';

class ShowService {
  ShowService({
    required TvMazeRepository tvMazeRepository,
  }) : _tvMazeRepository = tvMazeRepository;

  final TvMazeRepository _tvMazeRepository;

  Future<List<Show>> getAllShows() async {
    final jsonResponse = await _tvMazeRepository.getAllShows();
    return jsonResponse.map((json) => Show.fromJson(json)).toList();
  }
}

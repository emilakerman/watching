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

  // TODO(Emil): Filter right away and create different lists for each genre and store in a cubit?
  // Several cubits? Local storage?
  Future<List<Show>> filterByGenre() {
    final allShows = getAllShows();
    return allShows.then((shows) {
      return shows.where((show) => show.genres.contains('Drama')).toList();
    });
  }
}

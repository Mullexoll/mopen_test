import '../../constants/url_consts.dart';
import '../../domain/models/movie.model.dart';
import '../../services/api.service.dart';

class FetchLatestMoviesAPI {
  final APIService apiService;

  FetchLatestMoviesAPI({required this.apiService});

  Future<List<Movie>?> fetch({required String page}) async {
    try {
      final data = await apiService.get(Constants.latestMovie, null, page);
      final List latestMovies = data['results'];

      final List<Movie> movieList =
          latestMovies.map((json) => Movie.fromJson(json)).toList();

      return movieList;
    } catch (e, s) {
      print('ERROR $e, $s');
    }

    return null;
  }
}

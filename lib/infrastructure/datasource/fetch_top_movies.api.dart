import '../../constants/url_consts.dart';
import '../../domain/models/movie.model.dart';
import '../../services/api.service.dart';

class FetchTopMoviesAPI {
  final APIService apiService;

  FetchTopMoviesAPI({required this.apiService});

  Future<List<Movie>?> fetch() async {
    try {
      final data = await apiService.get(Constants.topRated, null, '1');

      final trendingMovies = data['results'];
      final topFiveMovies = trendingMovies.take(5).toList();

      final List<Movie> movieList =
          topFiveMovies.map<Movie>((json) => Movie.fromJson(json)).toList();

      return movieList;
    } catch (e, s) {
      print('ERROR $e, $s');
    }

    return null;
  }
}

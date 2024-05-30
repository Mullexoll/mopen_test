import 'package:mopen_test/constants/url_consts.dart';
import 'package:mopen_test/services/api.service.dart';

import '../../domain/models/movie.model.dart';

class FetchTopMoviesAPI {
  final APIService apiService;

  FetchTopMoviesAPI({required this.apiService});

  Future<List<Movie>?> fetch() async {
    try {
      final data = await apiService.get(Constants.topRated, null);

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

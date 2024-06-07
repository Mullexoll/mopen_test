import '../../constants/url_consts.dart';
import '../../domain/models/movie.model.dart';
import '../../services/api.service.dart';

class FetchSearchedMoviesAPI {
  final APIService apiService;

  FetchSearchedMoviesAPI({required this.apiService});

  Future<List<Movie>?> fetch(String query) async {
    try {
      final data = await apiService.get(
          Constants.searchFromQuery, query.toLowerCase(), '1');
      final List searchedMovies = data['results'];

      final List<Movie> movieList =
          searchedMovies.map((json) => Movie.fromJson(json)).toList();

      return movieList;
    } catch (e, s) {
      print('ERROR $e, $s');
    }

    return null;
  }
}

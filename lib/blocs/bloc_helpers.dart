import '../domain/models/genre.model.dart';
import '../domain/models/movie.model.dart';

List<Movie> mapMoviesWithGenres(List<Movie> movies, List<Genre> genres) {
  final genreMap = {for (var genre in genres) genre.id: genre.name};

  return movies.map((movie) {
    final genreNames = movie.genreIds
        ?.map(
          (id) => genreMap[id] ?? 'Unknown',
        )
        .toList();

    return Movie.withGenres(movie, genreNames ?? []);
  }).toList();
}

List<Movie> markFavorites({
  required List<Movie> listMovie,
  required List<Movie> favoriteMovies,
}) {
  final favoriteTitles = favoriteMovies.map((movie) => movie.id).toSet();

  return listMovie.map((movie) {
    final isFavorite = favoriteTitles.contains(movie.id);

    return Movie.withFavoriteStatus(movie, isFavorite);
  }).toList();
}

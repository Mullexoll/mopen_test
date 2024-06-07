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

    return Movie(
      movie.isFavorite,
      adult: movie.adult,
      backdropPath: movie.backdropPath,
      id: movie.id,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      video: movie.video,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      genreIds: movie.genreIds,
      genres: genreNames ?? [],
    );
  }).toList();
}

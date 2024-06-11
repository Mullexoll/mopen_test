part of 'latest_movies_bloc.dart';

@immutable
sealed class LatestMoviesEvent {}

class FetchLatestMovies extends LatestMoviesEvent {
  final int page;

  FetchLatestMovies({required this.page});
}

class AddLatestMovieToFavorite extends LatestMoviesEvent {
  final Movie movie;

  AddLatestMovieToFavorite({required this.movie});
}

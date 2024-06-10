part of 'search_movies_bloc.dart';

@immutable
sealed class SearchMoviesEvent {}

class FetchSearchedMovies extends SearchMoviesEvent {
  final int page;
  final String query;

  FetchSearchedMovies({
    required this.query,
    required this.page,
  });
}

class ClearSearchedList extends SearchMoviesEvent {}

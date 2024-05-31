part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class FetchTopMovies extends AppEvent {}

class FetchLatestMovies extends AppEvent {}

class FetchSearchedMovies extends AppEvent {
  final String query;

  FetchSearchedMovies({required this.query});
}

class ClearSearchedList extends AppEvent {}

class InitLocalDB extends AppEvent {}

class FavoriteHandler extends AppEvent {
  final Movie movie;

  FavoriteHandler({required this.movie});
}

class AddCurrentLocal extends AppEvent {
  final String currentLocal;

  AddCurrentLocal({required this.currentLocal});
}

part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class FetchTopMovies extends AppEvent {}

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

class AddCurrentTabIndex extends AppEvent {
  final int currentIndex;

  AddCurrentTabIndex({required this.currentIndex});
}

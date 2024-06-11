part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class FetchTopMovies extends AppEvent {}

class InitLocalDB extends AppEvent {}

class FavoriteHandler extends AppEvent {
  final Movie movie;

  FavoriteHandler({required this.movie});
}

class GetFavoriteMovies extends AppEvent {}

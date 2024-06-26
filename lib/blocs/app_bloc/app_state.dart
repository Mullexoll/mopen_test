part of 'app_bloc.dart';

@immutable
sealed class AppState extends Equatable {}

final class AppLoading extends AppState {
  @override
  List<Object?> get props => [];
}

final class AppLoaded extends AppState {
  final List<Movie> topMovies;
  final List<Movie> latestMovies;
  final List<Movie> searchedMovies;
  final List<Movie> favoritesMovies;
  final String connectionStatus;

  AppLoaded({
    required this.topMovies,
    required this.latestMovies,
    required this.searchedMovies,
    required this.favoritesMovies,
    required this.connectionStatus,
  });

  AppLoaded copyWith({
    List<Movie>? topMovies,
    List<Movie>? latestMovies,
    List<Movie>? searchedMovies,
    List<Movie>? favoritesMovies,
    String? connectionStatus,
    int? currentTabIndex,
  }) {
    return AppLoaded(
      topMovies: topMovies ?? this.topMovies,
      latestMovies: latestMovies ?? this.latestMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
      favoritesMovies: favoritesMovies ?? this.favoritesMovies,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
        topMovies,
        latestMovies,
        searchedMovies,
        favoritesMovies,
        connectionStatus,
      ];
}

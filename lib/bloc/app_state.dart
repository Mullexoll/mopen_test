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
  final bool isSearching;
  final String connectionStatus;
  final String currentLocal;

  AppLoaded({
    required this.topMovies,
    required this.latestMovies,
    required this.searchedMovies,
    required this.isSearching,
    required this.favoritesMovies,
    required this.connectionStatus,
    required this.currentLocal,
  });

  AppLoaded copyWith({
    List<Movie>? topMovies,
    List<Movie>? latestMovies,
    List<Movie>? searchedMovies,
    List<Movie>? favoritesMovies,
    bool? isSearching,
    String? connectionStatus,
    String? currentLocal,
  }) {
    return AppLoaded(
      topMovies: topMovies ?? this.topMovies,
      latestMovies: latestMovies ?? this.latestMovies,
      searchedMovies: searchedMovies ?? this.searchedMovies,
      favoritesMovies: favoritesMovies ?? this.favoritesMovies,
      isSearching: isSearching ?? this.isSearching,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      currentLocal: currentLocal ?? this.currentLocal,
    );
  }

  @override
  List<Object?> get props => [
        topMovies,
        latestMovies,
        searchedMovies,
        favoritesMovies,
        isSearching,
        connectionStatus,
        currentLocal,
      ];
}

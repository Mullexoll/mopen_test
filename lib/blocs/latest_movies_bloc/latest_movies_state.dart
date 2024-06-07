part of 'latest_movies_bloc.dart';

@immutable
class LatestMoviesState extends Equatable {
  final List<Movie> latestMovies;
  final int currentPage;
  final bool isLoading;

  const LatestMoviesState({
    required this.latestMovies,
    required this.currentPage,
    required this.isLoading,
  });

  LatestMoviesState copyWith({
    List<Movie>? latestMovies,
    int? currentPage,
    bool? isLoading,
  }) {
    return LatestMoviesState(
      latestMovies: latestMovies ?? this.latestMovies,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        latestMovies,
        currentPage,
        isLoading,
      ];
}

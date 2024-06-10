part of 'search_movies_bloc.dart';

@immutable
class SearchMoviesState extends Equatable {
  final List<Movie> searchedMovies;
  final int currentPage;
  final bool isLoading;

  const SearchMoviesState({
    required this.searchedMovies,
    required this.currentPage,
    required this.isLoading,
  });

  SearchMoviesState copyWith({
    List<Movie>? searchedMovies,
    int? currentPage,
    bool? isLoading,
  }) {
    return SearchMoviesState(
      searchedMovies: searchedMovies ?? this.searchedMovies,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        searchedMovies,
        currentPage,
        isLoading,
      ];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../constants/genres_const.dart';
import '../../domain/models/movie.model.dart';
import '../../infrastructure/datasource/fetch_searched_movies.api.dart';
import '../../infrastructure/repositories/isar_favorite_repository.dart';
import '../../services/api.service.dart';
import '../bloc_helpers.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final APIService apiService = APIService();
  final FavoriteMoviesRepository favoriteMoviesRepository =
      GetIt.instance<FavoriteMoviesRepository>();

  SearchMoviesBloc()
      : super(
          SearchMoviesState(
            searchedMovies: List.from(
              [],
            ),
            currentPage: 1,
            isLoading: false,
          ),
        ) {
    on<FetchSearchedMovies>(_onFetchSearchedMovies);
    on<ClearSearchedList>(_onClearSearchedList);
    on<AddSearchedMovieToFavorite>(_onAddSearchedMovieToFavorite);
  }

  Future<FutureOr<void>> _onFetchSearchedMovies(
    FetchSearchedMovies event,
    Emitter<SearchMoviesState> emit,
  ) async {
    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
      final List<Movie>? fetchedSearchedMovies =
          await FetchSearchedMoviesAPI(apiService: apiService).fetch(
        event.query,
        event.page.toString(),
      );
      emit(state.copyWith(isLoading: false));

      final List<Movie> favoriteMovies = await getLocalRepository();

      if (fetchedSearchedMovies != null) {
        final List<Movie> moviesWithGenres = mapMoviesWithGenres(
          fetchedSearchedMovies,
          GetIt.I<Locale>().languageCode == 'uk'
              ? GenresConst().genresUK
              : GenresConst().genresEN,
        );
        final List<Movie> markedMovies = markFavorites(
          listMovie: moviesWithGenres,
          favoriteMovies: favoriteMovies,
        );
        List<Movie> searchedMovies = List.from(state.searchedMovies)
          ..addAll(markedMovies);
        emit(
          state.copyWith(
            searchedMovies: searchedMovies,
            currentPage: event.page + 1,
          ),
        );
      } else {
        emit(
          state.copyWith(
            searchedMovies: [],
            currentPage: 1,
          ),
        );
      }
    }
  }

  FutureOr<void> _onClearSearchedList(
    ClearSearchedList event,
    Emitter<SearchMoviesState> emit,
  ) {
    emit(state.copyWith(searchedMovies: []));
  }

  Future<List<Movie>> getLocalRepository() async {
    return await favoriteMoviesRepository.getAllRepositories();
  }

  Future<FutureOr<void>> _onAddSearchedMovieToFavorite(
    AddSearchedMovieToFavorite event,
    Emitter<SearchMoviesState> emit,
  ) async {
    bool isDataWritten = await favoriteMoviesRepository.addToFavorite(
      movie: Movie.withFavoriteStatus(event.movie, true),
    );

    if (isDataWritten) {
      final List<Movie> favoriteRepositories =
          await favoriteMoviesRepository.getAllRepositories();
      final List<Movie> searchedMovies = state.searchedMovies;
      final List<Movie> markedSearchedMovies = markFavorites(
        listMovie: searchedMovies,
        favoriteMovies: favoriteRepositories,
      );

      emit(state.copyWith(searchedMovies: markedSearchedMovies));
    } else {
      final _ = await favoriteMoviesRepository.deleteRepository(event.movie.id);
      final List<Movie> favoriteRepositories =
          await favoriteMoviesRepository.getAllRepositories();
      final List<Movie> searchedMovies = state.searchedMovies;
      final List<Movie> markedSearchedMovies = markFavorites(
        listMovie: searchedMovies,
        favoriteMovies: favoriteRepositories,
      );
      emit(state.copyWith(searchedMovies: markedSearchedMovies));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../constants/genres_const.dart';
import '../../domain/models/movie.model.dart';
import '../../infrastructure/datasource/fetch_latest_movies.api.dart';
import '../../infrastructure/repositories/isar_favorite_repository.dart';
import '../../services/api.service.dart';
import '../bloc_helpers.dart';

part 'latest_movies_event.dart';
part 'latest_movies_state.dart';

class LatestMoviesBloc extends Bloc<LatestMoviesEvent, LatestMoviesState> {
  final APIService apiService = APIService();
  final GetIt getIt = GetIt.instance;
  final FavoriteMoviesRepository favoriteMoviesRepository =
      GetIt.instance<FavoriteMoviesRepository>();

  LatestMoviesBloc()
      : super(
          LatestMoviesState(
            latestMovies: List.from([]),
            currentPage: 1,
            isLoading: false,
          ),
        ) {
    on<FetchLatestMovies>(_onFetchLatestMovies);
    on<AddLatestMovieToFavorite>(_onAddToFavorite);
  }

  Future<FutureOr<void>> _onFetchLatestMovies(
    FetchLatestMovies event,
    Emitter<LatestMoviesState> emit,
  ) async {
    if (!state.isLoading) {
      emit(state.copyWith(isLoading: true));
      final List<Movie>? fetchedLatestMovies =
          await FetchLatestMoviesAPI(apiService: apiService).fetch(
        page: event.page.toString(),
      );
      final List<Movie> favoriteRepositories =
          await favoriteMoviesRepository.getAllRepositories();
      emit(state.copyWith(isLoading: false));

      final List<Movie> latestMoviesWithGenres = mapMoviesWithGenres(
        fetchedLatestMovies ?? [],
        GetIt.I<Locale>().languageCode == 'uk'
            ? GenresConst().genresUK
            : GenresConst().genresEN,
      );
      List<Movie> latestMovies = List.from(state.latestMovies)
        ..addAll(latestMoviesWithGenres);
      final List<Movie> markedLatestMovies = markFavorites(
        listMovie: latestMovies,
        favoriteMovies: favoriteRepositories,
      );

      emit(state.copyWith(
        latestMovies: markedLatestMovies,
        currentPage: event.page + 1,
      ));
    }
  }

  Future<FutureOr<void>> _onAddToFavorite(
    AddLatestMovieToFavorite event,
    Emitter<LatestMoviesState> emit,
  ) async {
    bool isDataWritten = await favoriteMoviesRepository.addToFavorite(
      movie: Movie.withFavoriteStatus(event.movie, true),
    );

    if (isDataWritten) {
      final List<Movie> favoriteRepositories =
          await favoriteMoviesRepository.getAllRepositories();
      final List<Movie> latestMovies = state.latestMovies;
      final List<Movie> markedLatestMovies = markFavorites(
        listMovie: latestMovies,
        favoriteMovies: favoriteRepositories,
      );

      emit(state.copyWith(latestMovies: markedLatestMovies));
    } else {
      final _ = await favoriteMoviesRepository.deleteRepository(event.movie.id);
      final List<Movie> favoriteRepositories =
          await favoriteMoviesRepository.getAllRepositories();
      final List<Movie> latestMovies = state.latestMovies;
      final List<Movie> markedLatestMovies = markFavorites(
        listMovie: latestMovies,
        favoriteMovies: favoriteRepositories,
      );
      emit(state.copyWith(latestMovies: markedLatestMovies));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../constants/genres_const.dart';
import '../../domain/models/movie.model.dart';
import '../../infrastructure/datasource/fetch_latest_movies.api.dart';
import '../../services/api.service.dart';
import '../bloc_helpers.dart';

part 'latest_movies_event.dart';
part 'latest_movies_state.dart';

class LatestMoviesBloc extends Bloc<LatestMoviesEvent, LatestMoviesState> {
  final APIService apiService = APIService();
  final GetIt getIt = GetIt.instance;

  LatestMoviesBloc()
      : super(
          LatestMoviesState(
            latestMovies: List.from([]),
            currentPage: 1,
            isLoading: false,
          ),
        ) {
    on<FetchLatestMovies>(_onFetchLatestMovies);
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
      emit(state.copyWith(isLoading: false));

      final List<Movie> latestMoviesWithGenres = mapMoviesWithGenres(
        fetchedLatestMovies ?? [],
        GetIt.I<Locale>().languageCode == 'uk'
            ? GenresConst().genresUK
            : GenresConst().genresEN,
      );
      List<Movie> latestMovies = List.from(state.latestMovies)
        ..addAll(latestMoviesWithGenres);

      emit(state.copyWith(
        latestMovies: latestMovies,
        currentPage: event.page + 1,
      ));
    }
  }
}

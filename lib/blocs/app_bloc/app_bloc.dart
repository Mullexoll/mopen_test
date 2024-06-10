import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/connection_status_consts.dart';
import '../../constants/genres_const.dart';
import '../../domain/models/genre.model.dart';
import '../../domain/models/movie.model.dart';
import '../../infrastructure/datasource/fetch_top_movies.api.dart';
import '../../infrastructure/repositories/isar_favorite_repository.dart';
import '../../services/api.service.dart';
import '../bloc_helpers.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late Isar isar;
  final APIService apiService = APIService();
  final Connectivity _connectivity = Connectivity();
  final GetIt getIt = GetIt.instance;
  late FavoriteMoviesRepository favoriteMoviesRepository;

  AppBloc() : super(AppLoading()) {
    on<FetchTopMovies>(_onFetchTopMovies);
    on<InitLocalDB>(_onInitLocalDB);
    on<FavoriteHandler>(_onFavoriteHandler);
  }

  FutureOr<void> _onFetchTopMovies(
    FetchTopMovies event,
    Emitter<AppState> emit,
  ) async {
    final String connectionStatus = await _checkConnectivity();

    if (connectionStatus == ConnectionStatusConsts.connected) {
      final List<Movie>? topMovies =
          await FetchTopMoviesAPI(apiService: apiService).fetch();

      if (topMovies != null) {
        final List<Movie> moviesWithGenres = mapMoviesWithGenres(
          topMovies,
          GetIt.I<Locale>().languageCode == 'uk'
              ? GenresConst().genresUK
              : GenresConst().genresEN,
        );

        if (state is AppLoaded) {
          emit(
            (state as AppLoaded).copyWith(
              topMovies: moviesWithGenres,
            ),
          );
        } else {
          emit(
            AppLoaded(
              latestMovies: List.from([]),
              searchedMovies: List.from([]),
              favoritesMovies: List.from([]),
              topMovies: moviesWithGenres,
              connectionStatus: connectionStatus,
            ),
          );
        }
        add(InitLocalDB());
      }
    } else if (connectionStatus == ConnectionStatusConsts.noConnection) {
      await initIsarRepository();
      final List<Movie> favoriteRepositories = await getLocalRepository();

      emit(
        AppLoaded(
          topMovies: List.from([]),
          latestMovies: List.from([]),
          searchedMovies: List.from([]),
          favoritesMovies: favoriteRepositories,
          connectionStatus: connectionStatus,
        ),
      );
    }
  }

  List<Movie> mapMoviesWithGenres(List<Movie> movies, List<Genre> genres) {
    final genreMap = {for (var genre in genres) genre.id: genre.name};

    return movies.map((movie) {
      final genreNames = movie.genreIds
          ?.map(
            (id) => genreMap[id] ?? 'Unknown',
          )
          .toList();

      return Movie(
        movie.isFavorite,
        adult: movie.adult,
        backdropPath: movie.backdropPath,
        id: movie.id,
        originalLanguage: movie.originalLanguage,
        originalTitle: movie.originalTitle,
        overview: movie.overview,
        popularity: movie.popularity,
        posterPath: movie.posterPath,
        releaseDate: movie.releaseDate,
        title: movie.title,
        video: movie.video,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
        genreIds: movie.genreIds,
        genres: genreNames ?? [],
      );
    }).toList();
  }

  Future<FutureOr<void>> _onInitLocalDB(
    InitLocalDB event,
    Emitter<AppState> emit,
  ) async {
    await initIsarRepository();
    final List<Movie> topMovies = (state as AppLoaded).topMovies;
    final List<Movie> latestMovies = (state as AppLoaded).latestMovies;
    final List<Movie> favoriteRepositories = await getLocalRepository();
    final List<Movie> markedMovies = markFavorites(
      listMovie: topMovies,
      favoriteMovies: favoriteRepositories,
    );
    final List<Movie> markedLatestMovies = markFavorites(
      listMovie: latestMovies,
      favoriteMovies: favoriteRepositories,
    );

    emit(
      (state as AppLoaded).copyWith(
        favoritesMovies: favoriteRepositories,
        topMovies: markedMovies,
        latestMovies: markedLatestMovies,
      ),
    );
  }

  Future<FutureOr<void>> _onFavoriteHandler(
    FavoriteHandler event,
    Emitter<AppState> emit,
  ) async {
    bool isDataWritten = await favoriteMoviesRepository.addItemToFavorite(
      repositoryFavorite: Movie(
        true,
        id: event.movie.id,
        adult: event.movie.adult,
        backdropPath: event.movie.backdropPath,
        genreIds: event.movie.genreIds,
        originalLanguage: event.movie.originalLanguage,
        originalTitle: event.movie.originalTitle,
        overview: event.movie.overview,
        popularity: event.movie.popularity,
        posterPath: event.movie.posterPath,
        releaseDate: event.movie.releaseDate,
        title: event.movie.title,
        video: event.movie.video,
        voteAverage: event.movie.voteAverage,
        voteCount: event.movie.voteCount,
        genres: event.movie.genres,
      ),
    );

    if (isDataWritten) {
      final List<Movie> favoriteRepositories = await getLocalRepository();
      final List<Movie> topMovies = (state as AppLoaded).topMovies;
      final List<Movie> searchedMovies = (state as AppLoaded).searchedMovies;
      final List<Movie> markedSearchedMovies = markFavorites(
        listMovie: searchedMovies,
        favoriteMovies: favoriteRepositories,
      );
      final List<Movie> markedMovies = markFavorites(
        listMovie: topMovies,
        favoriteMovies: favoriteRepositories,
      );
      final List<Movie> latestMovies = (state as AppLoaded).latestMovies;
      final List<Movie> markedLatestMovies = markFavorites(
        listMovie: latestMovies,
        favoriteMovies: favoriteRepositories,
      );

      emit(
        (state as AppLoaded).copyWith(
          favoritesMovies: favoriteRepositories,
          topMovies: markedMovies,
          latestMovies: markedLatestMovies,
          searchedMovies: markedSearchedMovies,
        ),
      );
    } else {
      final _ = await favoriteMoviesRepository.deleteRepository(event.movie.id);
      final List<Movie> favoriteRepositories = await getLocalRepository();
      final List<Movie> searchedMovies = (state as AppLoaded).searchedMovies;
      final List<Movie> markedSearchedMovies = markFavorites(
        listMovie: searchedMovies,
        favoriteMovies: favoriteRepositories,
      );
      final List<Movie> topMovies = (state as AppLoaded).topMovies;
      final List<Movie> latestMovies = (state as AppLoaded).latestMovies;
      final List<Movie> markedTopMovies = markFavorites(
        listMovie: topMovies,
        favoriteMovies: favoriteRepositories,
      );
      final List<Movie> markedLatestMovies = markFavorites(
        listMovie: latestMovies,
        favoriteMovies: favoriteRepositories,
      );

      emit(
        (state as AppLoaded).copyWith(
          favoritesMovies: favoriteRepositories,
          topMovies: markedTopMovies,
          latestMovies: markedLatestMovies,
          searchedMovies: markedSearchedMovies,
        ),
      );
    }
  }

  Future<String> _checkConnectivity() async {
    String connectionStatus = ConnectionStatusConsts.unknownConnection;

    List<ConnectivityResult> result = [];
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result.add(ConnectivityResult.none);
    }

    switch (result.first) {
      case ConnectivityResult.none:
        connectionStatus = ConnectionStatusConsts.noConnection;
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        connectionStatus = ConnectionStatusConsts.connected;
        break;
      default:
        connectionStatus = ConnectionStatusConsts.unknownConnection;
        break;
    }

    return connectionStatus;
  }

  initIsarRepository() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MovieSchema],
      name: 'FavoriteMovieRepositoryIsarDB',
      directory: dir.path,
    );

    favoriteMoviesRepository = FavoriteMoviesRepository(isar);
    GetIt.instance
        .registerSingleton<FavoriteMoviesRepository>(favoriteMoviesRepository);
  }

  Future<List<Movie>> getLocalRepository() async {
    return await favoriteMoviesRepository.getAllRepositories();
  }
}

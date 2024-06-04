import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:meta/meta.dart';
import 'package:mopen_test/constants/connection_status_consts.dart';
import 'package:mopen_test/constants/genres_const.dart';
import 'package:mopen_test/infrastructure/datasource/fetch_searched_movies.api.dart';
import 'package:mopen_test/infrastructure/datasource/fetch_top_movies.api.dart';
import 'package:mopen_test/services/api.service.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/models/genre.model.dart';
import '../domain/models/movie.model.dart';
import '../infrastructure/datasource/fetch_latest_movies.api.dart';
import '../infrastructure/repositories/isar_favorite_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late Isar _isarRepository;
  final APIService apiService = APIService();
  final Connectivity _connectivity = Connectivity();

  AppBloc() : super(AppLoading()) {
    on<FetchTopMovies>(_onFetchTopMovies);
    on<FetchLatestMovies>(_onFetchLatestMovies);
    on<FetchSearchedMovies>(_onFetchSearchedMovies);
    on<ClearSearchedList>(_onClearSearchedList);
    on<InitLocalDB>(_onInitLocalDB);
    on<FavoriteHandler>(_onFavoriteHandler);
    on<AddCurrentLocal>(_onAddCurrentLocal);
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
          GenresConst().genres,
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
              isSearching: false,
              connectionStatus: connectionStatus,
            ),
          );
        }
        add(InitLocalDB());
      }
    } else if (connectionStatus == ConnectionStatusConsts.noConnection) {
      await initIsarRepository();
      final List<Movie> favoriteRepositories =
          await RepositoryIsarInstanceUseCase(_isarRepository)
              .getAllRepositories();

      emit(
        AppLoaded(
          topMovies: List.from([]),
          latestMovies: List.from([]),
          searchedMovies: List.from([]),
          isSearching: false,
          favoritesMovies: favoriteRepositories,
          connectionStatus: connectionStatus,
        ),
      );
    }
  }

  Future<FutureOr<void>> _onFetchLatestMovies(
    FetchLatestMovies event,
    Emitter<AppState> emit,
  ) async {
    final List<Movie>? latestMovies =
        await FetchLatestMoviesAPI(apiService: apiService).fetch();

    if (latestMovies != null) {
      final List<Movie> moviesWithGenres = mapMoviesWithGenres(
        latestMovies,
        GenresConst().genres,
      );

      if (state is AppLoaded) {
        emit(
          (state as AppLoaded).copyWith(
            latestMovies: moviesWithGenres,
          ),
        );
      } else {
        emit(
          AppLoaded(
            latestMovies: moviesWithGenres,
            topMovies: List.from([]),
            searchedMovies: List.from([]),
            favoritesMovies: List.from([]),
            isSearching: false,
            connectionStatus: ConnectionStatusConsts.unknownConnection,
          ),
        );
      }
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

  FutureOr<void> _onFetchSearchedMovies(
    FetchSearchedMovies event,
    Emitter<AppState> emit,
  ) async {
    emit((state as AppLoaded).copyWith(isSearching: true));
    final List<Movie>? searchedMovies =
        await FetchSearchedMoviesAPI(apiService: apiService).fetch(event.query);
    emit((state as AppLoaded).copyWith(isSearching: false));

    if (searchedMovies != null) {
      final List<Movie> moviesWithGenres = mapMoviesWithGenres(
        searchedMovies,
        GenresConst().genres,
      );
      final List<Movie> markedMovies = markFavorites(
        listMovie: moviesWithGenres,
        favoriteMovies: (state as AppLoaded).favoritesMovies,
      );
      emit((state as AppLoaded).copyWith(searchedMovies: markedMovies));
    } else {
      emit((state as AppLoaded).copyWith(searchedMovies: []));
    }
  }

  FutureOr<void> _onClearSearchedList(
    ClearSearchedList event,
    Emitter<AppState> emit,
  ) {
    emit((state as AppLoaded).copyWith(searchedMovies: []));
  }

  Future<FutureOr<void>> _onInitLocalDB(
    InitLocalDB event,
    Emitter<AppState> emit,
  ) async {
    await initIsarRepository();
    final List<Movie> topMovies = (state as AppLoaded).topMovies;
    final List<Movie> latestMovies = (state as AppLoaded).latestMovies;
    final List<Movie> favoriteRepositories =
        await RepositoryIsarInstanceUseCase(_isarRepository)
            .getAllRepositories();
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
    bool isDataWritten =
        await RepositoryIsarInstanceUseCase(_isarRepository).addItemToFavorite(
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
      final List<Movie> favoriteRepositories =
          await RepositoryIsarInstanceUseCase(_isarRepository)
              .getAllRepositories();
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
      final _ = await RepositoryIsarInstanceUseCase(_isarRepository)
          .deleteRepository(event.movie.id);
      final List<Movie> favoriteRepositories =
          await RepositoryIsarInstanceUseCase(_isarRepository)
              .getAllRepositories();
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

  List<Movie> markFavorites({
    required List<Movie> listMovie,
    required List<Movie> favoriteMovies,
  }) {
    final favoriteTitles = favoriteMovies.map((movie) => movie.id).toSet();

    return listMovie.map((movie) {
      final isFavorite = favoriteTitles.contains(movie.id);

      return Movie(
        isFavorite,
        id: movie.id,
        adult: movie.adult,
        backdropPath: movie.backdropPath,
        genreIds: movie.genreIds,
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
        genres: movie.genres,
      );
    }).toList();
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
    _isarRepository = await Isar.open(
      [MovieSchema],
      name: 'FavoriteMovieRepositoryIsarDB',
      directory: dir.path,
    );
  }

  FutureOr<void> _onAddCurrentLocal(
    AddCurrentLocal event,
    Emitter<AppState> emit,
  ) {
    if (state is AppLoading) {
      emit(AppLoaded(
        latestMovies: List.from([]),
        topMovies: List.from([]),
        searchedMovies: List.from([]),
        favoritesMovies: List.from([]),
        isSearching: false,
        connectionStatus: ConnectionStatusConsts.unknownConnection,
      ));
    }
  }
}

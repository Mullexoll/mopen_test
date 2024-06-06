import 'package:isar/isar.dart';

import '../../domain/models/movie.model.dart';

class RepositoryIsarInstanceUseCase {
  final IsarCollection<Movie> _storage;
  final Isar _isar;

  RepositoryIsarInstanceUseCase(this._isar)
      : _storage = _isar.collection<Movie>();

  Future<bool> addRepositoryToIsar({
    required Movie repository,
  }) async {
    try {
      final foundRepository = await _storage.get(repository.id);

      if (foundRepository == null) {
        await _isar.writeTxn(() async => await _storage.put(repository));
      } else {
        if (foundRepository.isFavorite! &&
            foundRepository.id == repository.id) {
          await _isar
              .writeTxn(() async => await _storage.delete(repository.id));
        }
      }
      return true;
    } catch (e, s) {
      print('ERROR $e $s');
      return false;
    }
  }

  Future<bool> addItemToFavorite({
    required Movie repositoryFavorite,
  }) async {
    try {
      final foundRepository = await _storage.get(repositoryFavorite.id);

      if (foundRepository != null && !foundRepository.isFavorite!) {
        await _isar.writeTxn(
          () async => await _storage.delete(repositoryFavorite.id),
        );
        await _isar
            .writeTxn(() async => await _storage.put(repositoryFavorite));
      } else {
        await _isar.writeTxn(
          () async => await _storage.delete(repositoryFavorite.id),
        );
        await _isar.writeTxn(
          () async => await _storage.put(
            Movie(
              repositoryFavorite.isFavorite,
              id: repositoryFavorite.id,
              adult: repositoryFavorite.adult,
              backdropPath: repositoryFavorite.backdropPath,
              genreIds: repositoryFavorite.genreIds,
              originalLanguage: repositoryFavorite.originalLanguage,
              originalTitle: repositoryFavorite.originalTitle,
              overview: repositoryFavorite.overview,
              popularity: repositoryFavorite.popularity,
              posterPath: repositoryFavorite.posterPath,
              releaseDate: repositoryFavorite.releaseDate,
              title: repositoryFavorite.title,
              video: repositoryFavorite.video,
              voteAverage: repositoryFavorite.voteAverage,
              voteCount: repositoryFavorite.voteCount,
              genres: repositoryFavorite.genres,
            ),
          ),
        );
      }

      return true;
    } catch (e, s) {
      print('${e} ${s}');
    }

    return false;
  }

  Future<List<Movie>> getAllRepositories() {
    final foundRepositories = _storage.where().findAll();

    return foundRepositories;
  }

  Future<bool> deleteRepository(int id) async {
    bool isDeleted = await _isar.writeTxn(() async {
      return await _storage.deleteById(id);
    });

    print('isDeleted $isDeleted');

    return true;
  }
}

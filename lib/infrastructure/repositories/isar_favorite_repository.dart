import 'package:isar/isar.dart';

import '../../domain/models/movie.model.dart';

class FavoriteMoviesRepository {
  final IsarCollection<Movie> _storage;
  final Isar _isar;

  FavoriteMoviesRepository(this._isar) : _storage = _isar.collection<Movie>();

  Future<bool> addToFavorite({
    required Movie movie,
  }) async {
    try {
      final foundRepository = await _storage.getById(movie.id);

      if (foundRepository != null) {
        return false;
      } else {
        await _isar.writeTxn(
          () async => await _storage.delete(movie.id),
        );
        await _isar.writeTxn(
          () async => await _storage.put(
            Movie.withFavoriteStatus(movie, movie.isFavorite),
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

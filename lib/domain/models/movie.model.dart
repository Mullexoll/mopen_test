import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'movie.model.g.dart';

@Collection(ignore: {'props'})
class Movie extends Equatable {
  final Id autoId = Isar.autoIncrement;
  final bool adult;
  final String backdropPath;
  final List<int>? genreIds;
  @Index(unique: true)
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String? overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final List<String> genres;
  final bool isFavorite;

  const Movie(
    this.isFavorite, {
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      false,
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'].toString(),
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: json['popularity'].toDouble() ?? 0,
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
      video: json['video'] ?? '',
      voteAverage: json['vote_average'].toDouble() ?? 0,
      voteCount: json['vote_count'] ?? 0,
      genres: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'id': id,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': video,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalLanguage,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
        genres,
      ];
}

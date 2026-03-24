import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel extends Movie {
  @override
  @HiveField(0)
  final int id;
  
  @override
  @HiveField(1)
  final String title;
  
  @override
  @HiveField(2)
  final String originalTitle;
  
  @override
  @HiveField(3)
  final String overview;
  
  @override
  @HiveField(4)
  final String? posterPath;
  
  @override
  @HiveField(5)
  final String? backdropPath;
  
  @override
  @HiveField(6)
  final String releaseDate;
  
  @override
  @HiveField(7)
  final double voteAverage;
  
  @override
  @HiveField(8)
  final int voteCount;
  
  @override
  @HiveField(9)
  final double popularity;
  
  @override
  @HiveField(10)
  final List<int> genreIds;
  
  @override
  @HiveField(11)
  final bool adult;
  
  @override
  @HiveField(12)
  final String? originalLanguage;

  const MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.genreIds,
    this.adult = false,
    this.originalLanguage,
  }) : super(
          id: id,
          title: title,
          originalTitle: originalTitle,
          overview: overview,
          posterPath: posterPath,
          backdropPath: backdropPath,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          voteCount: voteCount,
          popularity: popularity,
          genreIds: genreIds,
          adult: adult,
          originalLanguage: originalLanguage,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      adult: json['adult'] as bool? ?? false,
      originalLanguage: json['original_language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
    };
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      popularity: movie.popularity,
      genreIds: movie.genreIds,
      adult: movie.adult,
      originalLanguage: movie.originalLanguage,
    );
  }
}

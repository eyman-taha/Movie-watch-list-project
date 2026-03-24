import 'package:equatable/equatable.dart';
import 'genre.dart';
import 'movie.dart';
import 'video.dart';
import 'credits.dart';

class MovieDetails extends Equatable {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final List<Genre> genres;
  final int? runtime;
  final String? status;
  final String? tagline;
  final int? budget;
  final int? revenue;
  final String? homepage;
  final String? imdbId;
  final String? originalLanguage;
  final List<Video> videos;
  final Credits? credits;

  const MovieDetails({
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
    required this.genres,
    this.runtime,
    this.status,
    this.tagline,
    this.budget,
    this.revenue,
    this.homepage,
    this.imdbId,
    this.originalLanguage,
    this.videos = const [],
    this.credits,
  });

  Video? get trailer {
    final officialTrailers = videos
        .where((v) => v.isTrailer && v.isYouTube && v.official)
        .toList();
    if (officialTrailers.isNotEmpty) return officialTrailers.first;

    final trailers = videos.where((v) => v.isTrailer && v.isYouTube).toList();
    return trailers.firstOrNull;
  }

  Movie toMovie() {
    return Movie(
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
      genreIds: genres.map((g) => g.id).toList(),
      originalLanguage: originalLanguage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    originalTitle,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
    popularity,
    genres,
    runtime,
    status,
    tagline,
    budget,
    revenue,
    homepage,
    imdbId,
    originalLanguage,
    videos,
    credits,
  ];
}

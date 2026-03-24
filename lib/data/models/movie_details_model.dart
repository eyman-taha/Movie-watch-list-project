import '../../domain/entities/movie_details.dart';
import 'genre_model.dart';
import 'video_model.dart';
import 'credits_model.dart';

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.originalTitle,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.releaseDate,
    required super.voteAverage,
    required super.voteCount,
    required super.popularity,
    required super.genres,
    super.runtime,
    super.status,
    super.tagline,
    super.budget,
    super.revenue,
    super.homepage,
    super.imdbId,
    super.originalLanguage,
    super.videos,
    super.credits,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final videosList = json['videos']?['results'] as List<dynamic>? ?? [];
    final creditsData = json['credits'] as Map<String, dynamic>?;

    return MovieDetailsModel(
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
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String?,
      videos: videosList
          .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      credits: creditsData != null ? CreditsModel.fromJson(creditsData) : null,
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
      'genres': genres.map((e) => GenreModel.fromEntity(e).toJson()).toList(),
      'runtime': runtime,
      'status': status,
      'tagline': tagline,
      'budget': budget,
      'revenue': revenue,
      'homepage': homepage,
      'imdb_id': imdbId,
      'original_language': originalLanguage,
      'videos': {'results': videos.map((e) => VideoModel(
        id: e.id,
        key: e.key,
        name: e.name,
        site: e.site,
        type: e.type,
        official: e.official,
      ).toJson()).toList()},
      'credits': credits != null ? CreditsModel(
        cast: credits!.cast.map((e) => CastMemberModel(
          id: e.id,
          name: e.name,
          character: e.character,
          profilePath: e.profilePath,
          order: e.order,
        )).toList(),
        crew: credits!.crew.map((e) => CrewMemberModel(
          id: e.id,
          name: e.name,
          job: e.job,
          profilePath: e.profilePath,
          department: e.department,
        )).toList(),
      ).toJson() : null,
    };
  }
}

import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_client.dart';
import '../../models/movie_details_model.dart';
import '../../models/paginated_response.dart';
import '../../models/credits_model.dart';
import '../../models/video_model.dart';
import '../../models/genre_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponse> getTrending({int page = 1});
  Future<MovieListResponse> getPopular({int page = 1});
  Future<MovieListResponse> getTopRated({int page = 1});
  Future<MovieListResponse> getNowPlaying({int page = 1});
  Future<MovieListResponse> getUpcoming({int page = 1});
  Future<MovieListResponse> searchMovies(String query, {int page = 1});
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<CreditsModel> getMovieCredits(int movieId);
  Future<List<VideoModel>> getMovieVideos(int movieId);
  Future<MovieListResponse> getSimilarMovies(int movieId, {int page = 1});
  Future<MovieListResponse> getRecommendedMovies(int movieId, {int page = 1});
  Future<MovieListResponse> discoverMovies({
    int? genreId,
    int? year,
    int? minRating,
    int? maxRating,
    String sortBy = 'popularity.desc',
    int page = 1,
  });
  Future<List<GenreModel>> getGenres();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final NetworkClient _networkClient;

  MovieRemoteDataSourceImpl(this._networkClient);

  @override
  Future<MovieListResponse> getTrending({int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.trending,
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> getPopular({int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.popular,
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> getTopRated({int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.topRated,
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> getNowPlaying({int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.nowPlaying,
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> getUpcoming({int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.upcoming,
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> searchMovies(String query, {int page = 1}) async {
    final response = await _networkClient.get(
      ApiEndpoints.search,
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final response = await _networkClient.get(
      ApiEndpoints.movieDetails(movieId),
      queryParameters: {'append_to_response': 'credits,videos'},
    );
    return MovieDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CreditsModel> getMovieCredits(int movieId) async {
    final response = await _networkClient.get(
      ApiEndpoints.movieCredits(movieId),
    );
    return CreditsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    final response = await _networkClient.get(
      ApiEndpoints.movieVideos(movieId),
    );
    final data = response.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MovieListResponse> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    final response = await _networkClient.get(
      ApiEndpoints.movieSimilar(movieId),
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> getRecommendedMovies(
    int movieId, {
    int page = 1,
  }) async {
    final response = await _networkClient.get(
      ApiEndpoints.movieRecommendations(movieId),
      queryParameters: {'page': page},
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MovieListResponse> discoverMovies({
    int? genreId,
    int? year,
    int? minRating,
    int? maxRating,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) async {
    final queryParams = <String, dynamic>{
      'sort_by': sortBy,
      'page': page,
      'include_adult': false,
    };

    if (genreId != null) {
      queryParams['with_genres'] = genreId.toString();
    }
    if (year != null) {
      queryParams['primary_release_year'] = year.toString();
    }
    if (minRating != null) {
      queryParams['vote_average.gte'] = minRating.toString();
    }
    if (maxRating != null) {
      queryParams['vote_average.lte'] = maxRating.toString();
    }

    final response = await _networkClient.get(
      ApiEndpoints.discoverMovies,
      queryParameters: queryParams,
    );
    return MovieListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _networkClient.get(ApiEndpoints.genres);
    final data = response.data as Map<String, dynamic>;
    final genres = data['genres'] as List<dynamic>? ?? [];
    return genres
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

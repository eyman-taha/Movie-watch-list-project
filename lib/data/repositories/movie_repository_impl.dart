import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/credits.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_remote_datasource.dart';
import '../datasources/local/local_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl({
    required MovieRemoteDataSource remoteDataSource,
    required MovieLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final cacheKey = 'trending_$page';
    final cached = await _localDataSource.getCachedMovies(cacheKey);

    try {
      final response = await _remoteDataSource.getTrending(page: page);
      await _localDataSource.cacheMovies(cacheKey, response.results);
      return response.results;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final cacheKey = 'popular_$page';
    final cached = await _localDataSource.getCachedMovies(cacheKey);

    try {
      final response = await _remoteDataSource.getPopular(page: page);
      await _localDataSource.cacheMovies(cacheKey, response.results);
      return response.results;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final cacheKey = 'top_rated_$page';
    final cached = await _localDataSource.getCachedMovies(cacheKey);

    try {
      final response = await _remoteDataSource.getTopRated(page: page);
      await _localDataSource.cacheMovies(cacheKey, response.results);
      return response.results;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final cacheKey = 'now_playing_$page';
    final cached = await _localDataSource.getCachedMovies(cacheKey);

    try {
      final response = await _remoteDataSource.getNowPlaying(page: page);
      await _localDataSource.cacheMovies(cacheKey, response.results);
      return response.results;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final cacheKey = 'upcoming_$page';
    final cached = await _localDataSource.getCachedMovies(cacheKey);

    try {
      final response = await _remoteDataSource.getUpcoming(page: page);
      await _localDataSource.cacheMovies(cacheKey, response.results);
      return response.results;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await _remoteDataSource.searchMovies(query, page: page);
    return response.results;
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    return await _remoteDataSource.getMovieDetails(movieId);
  }

  @override
  Future<Credits> getMovieCredits(int movieId) async {
    return await _remoteDataSource.getMovieCredits(movieId);
  }

  @override
  Future<List<Video>> getMovieVideos(int movieId) async {
    return await _remoteDataSource.getMovieVideos(movieId);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    final response = await _remoteDataSource.getSimilarMovies(
      movieId,
      page: page,
    );
    return response.results;
  }

  @override
  Future<List<Movie>> getRecommendedMovies(int movieId, {int page = 1}) async {
    final response = await _remoteDataSource.getRecommendedMovies(
      movieId,
      page: page,
    );
    return response.results;
  }

  @override
  Future<List<Movie>> discoverMovies({
    int? genreId,
    int? year,
    int? minRating,
    int? maxRating,
    String sortBy = 'popularity.desc',
    int page = 1,
  }) async {
    final response = await _remoteDataSource.discoverMovies(
      genreId: genreId,
      year: year,
      minRating: minRating,
      maxRating: maxRating,
      sortBy: sortBy,
      page: page,
    );
    return response.results;
  }

  @override
  Future<List<Genre>> getGenres() async {
    final cached = await _localDataSource.getCachedGenres();

    try {
      final genres = await _remoteDataSource.getGenres();
      await _localDataSource.cacheGenres(genres);
      return genres;
    } catch (e) {
      if (cached != null) return cached;
      rethrow;
    }
  }
}

import '../entities/movie.dart';
import '../entities/movie_details.dart';
import '../entities/genre.dart';
import '../entities/credits.dart';
import '../entities/video.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> getPopularMovies({int page = 1});
  Future<List<Movie>> getTopRatedMovies({int page = 1});
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<List<Movie>> getUpcomingMovies({int page = 1});
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<MovieDetails> getMovieDetails(int movieId);
  Future<Credits> getMovieCredits(int movieId);
  Future<List<Video>> getMovieVideos(int movieId);
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1});
  Future<List<Movie>> getRecommendedMovies(int movieId, {int page = 1});
  Future<List<Movie>> discoverMovies({
    int? genreId,
    int? year,
    int? minRating,
    int? maxRating,
    String sortBy = 'popularity.desc',
    int page = 1,
  });
  Future<List<Genre>> getGenres();
}

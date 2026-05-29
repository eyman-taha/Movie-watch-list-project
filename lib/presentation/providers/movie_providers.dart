import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/genre.dart';
import '../providers/providers.dart';

final trendingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getTrendingMovies();
});

final popularMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getPopularMovies();
});

final topRatedMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getTopRatedMovies();
});

final nowPlayingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getNowPlayingMovies();
});

final upcomingMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getUpcomingMovies();
});

final genresProvider = FutureProvider.autoDispose<List<Genre>>((ref) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.getGenres();
});

final movieDetailsProvider = FutureProvider.autoDispose
    .family<MovieDetails, int>((ref, movieId) async {
      final repository = ref.watch(movieRepositoryProvider);
      return repository.getMovieDetails(movieId);
    });

final similarMoviesProvider = FutureProvider.autoDispose
    .family<List<Movie>, int>((ref, movieId) async {
      final repository = ref.watch(movieRepositoryProvider);
      return repository.getSimilarMovies(movieId);
    });

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  final genre = ref.watch(selectedGenreProvider);
  final year = ref.watch(filterYearProvider);
  final rating = ref.watch(filterRatingProvider);
  final repository = ref.watch(movieRepositoryProvider);

  if (query.isNotEmpty) {
    return repository.searchMovies(query);
  }

  if (genre != null || year != null || rating != null) {
    return repository.discoverMovies(
      genreId: genre?.id,
      year: year,
      minRating: rating?.toInt(),
    );
  }

  return [];
});

final selectedGenreProvider = StateProvider<Genre?>((ref) => null);

final filterYearProvider = StateProvider<int?>((ref) => null);

final filterRatingProvider = StateProvider<double?>((ref) => null);



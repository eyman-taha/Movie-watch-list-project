import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/movie_repository.dart';
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
  if (query.isEmpty) return [];
  final repository = ref.watch(movieRepositoryProvider);
  return repository.searchMovies(query);
});

final selectedGenreProvider = StateProvider<Genre?>((ref) => null);

final filterYearProvider = StateProvider<int?>((ref) => null);

final filterRatingProvider = StateProvider<double?>((ref) => null);

final discoverMoviesProvider = FutureProvider.autoDispose<List<Movie>>((
  ref,
) async {
  final genre = ref.watch(selectedGenreProvider);
  final year = ref.watch(filterYearProvider);
  final rating = ref.watch(filterRatingProvider);

  final repository = ref.watch(movieRepositoryProvider);
  return repository.discoverMovies(
    genreId: genre?.id,
    year: year,
    minRating: rating?.toInt(),
  );
});

class PaginatedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository _repository;
  final Future<List<Movie>> Function(MovieRepository, int) _fetchFunc;
  bool _hasMore = true;
  int _page = 1;

  PaginatedMoviesNotifier(this._repository, this._fetchFunc)
    : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final movies = await _fetchFunc(_repository, _page);
      state = AsyncValue.data(movies);
      _hasMore = movies.length >= 20;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    final currentMovies = state.value ?? [];
    _page++;

    try {
      final newMovies = await _fetchFunc(_repository, _page);
      state = AsyncValue.data([...currentMovies, ...newMovies]);
      _hasMore = newMovies.length >= 20;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    await _load();
  }
}

final paginatedTrendingProvider =
    StateNotifierProvider.autoDispose<
      PaginatedMoviesNotifier,
      AsyncValue<List<Movie>>
    >((ref) {
      final repository = ref.watch(movieRepositoryProvider);
      return PaginatedMoviesNotifier(
        repository,
        (repo, page) => repo.getTrendingMovies(page: page),
      );
    });

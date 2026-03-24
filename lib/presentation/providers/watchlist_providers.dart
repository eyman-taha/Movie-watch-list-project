import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../providers/providers.dart';

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<WatchlistItem>>>((
      ref,
    ) {
      final repository = ref.watch(watchlistRepositoryProvider);
      return WatchlistNotifier(repository);
    });

class WatchlistNotifier extends StateNotifier<AsyncValue<List<WatchlistItem>>> {
  final WatchlistRepository _repository;

  WatchlistNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getAllItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addToWatchlist(
    Movie movie, {
    WatchlistStatus status = WatchlistStatus.planToWatch,
    bool isFavorite = false,
    String? userId,
  }) async {
    final now = DateTime.now();
    final item = WatchlistItem(
      userId: userId,
      movieId: movie.id,
      movie: movie,
      status: status,
      isFavorite: isFavorite,
      addedAt: now,
      updatedAt: now,
    );

    await _repository.addItem(item);
    await _load();
  }

  Future<void> updateStatus(int movieId, WatchlistStatus status) async {
    final item = await _repository.getItem(movieId);
    if (item != null) {
      final updated = item.copyWith(
        status: status,
        updatedAt: DateTime.now(),
        watchedAt: status == WatchlistStatus.watched ? DateTime.now() : null,
      );
      await _repository.updateItem(updated);
      await _load();
    }
  }

  Future<void> updateRating(int movieId, double rating) async {
    final item = await _repository.getItem(movieId);
    if (item != null) {
      final updated = item.copyWith(
        userRating: rating,
        updatedAt: DateTime.now(),
      );
      await _repository.updateItem(updated);
      await _load();
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    final item = await _repository.getItem(movieId);
    if (item != null) {
      final updated = item.copyWith(
        isFavorite: !item.isFavorite,
        updatedAt: DateTime.now(),
      );
      await _repository.updateItem(updated);
      await _load();
    }
  }

  Future<void> removeFromWatchlist(int movieId) async {
    await _repository.removeItem(movieId);
    await _load();
  }

  Future<void> refresh() async {
    await _load();
  }
}

final watchlistByStatusProvider =
    Provider.family<AsyncValue<List<WatchlistItem>>, WatchlistStatus>((
      ref,
      status,
    ) {
      final watchlist = ref.watch(watchlistProvider);
      return watchlist.whenData(
        (items) => items.where((item) => item.status == status).toList(),
      );
    });

final isInWatchlistProvider = FutureProvider.family<bool, int>((
  ref,
  movieId,
) async {
  final repository = ref.watch(watchlistRepositoryProvider);
  return repository.isInWatchlist(movieId);
});

final watchlistItemProvider = FutureProvider.family<WatchlistItem?, int>((
  ref,
  movieId,
) async {
  final repository = ref.watch(watchlistRepositoryProvider);
  return repository.getItem(movieId);
});

enum WatchlistViewMode { all, planToWatch, stillWatching, watched }

final watchlistViewModeProvider = StateProvider<WatchlistViewMode>(
  (ref) => WatchlistViewMode.all,
);

final filteredWatchlistProvider = Provider<AsyncValue<List<WatchlistItem>>>((
  ref,
) {
  final viewMode = ref.watch(watchlistViewModeProvider);
  final watchlist = ref.watch(watchlistProvider);

  return watchlist.whenData((items) {
    switch (viewMode) {
      case WatchlistViewMode.all:
        return items;
      case WatchlistViewMode.planToWatch:
        return items
            .where((item) => item.status == WatchlistStatus.planToWatch)
            .toList();
      case WatchlistViewMode.stillWatching:
        return items
            .where((item) => item.status == WatchlistStatus.stillWatching)
            .toList();
      case WatchlistViewMode.watched:
        return items
            .where((item) => item.status == WatchlistStatus.watched)
            .toList();
    }
  });
});

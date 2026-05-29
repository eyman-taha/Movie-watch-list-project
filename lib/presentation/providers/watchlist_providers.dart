import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../providers/providers.dart';

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<WatchlistItem>>>((ref) {
      final repository = ref.watch(watchlistRepositoryProvider);
      final user = ref.watch(currentUserProvider);
      final notifier = WatchlistNotifier(repository, user?.id);

      ref.listen(currentUserProvider, (previous, next) {
        if (previous?.id != next?.id) {
          notifier.syncWithUser(next?.id);
        }
      });

      return notifier;
    });

class WatchlistNotifier extends StateNotifier<AsyncValue<List<WatchlistItem>>> {
  final WatchlistRepository _repository;
  String? _userId;

  WatchlistNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading()) {
    _repository.setCurrentUser(_userId);
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      _repository.setCurrentUser(_userId);
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
    final effectiveUserId = userId ?? _userId;
    final now = DateTime.now();
    final item = WatchlistItem(
      userId: effectiveUserId,
      movieId: movie.id,
      movie: movie,
      status: status,
      isFavorite: isFavorite,
      addedAt: now,
      updatedAt: now,
    );

    final currentItems = List<WatchlistItem>.from(state.value ?? []);

    if (currentItems.any((i) => i.movieId == movie.id)) return;

    state = AsyncValue.data([item, ...currentItems]);

    try {
      await _repository.addItem(item);
    } catch (e) {
      state = AsyncValue.data(currentItems);
    }
  }

  Future<void> updateStatus(int movieId, WatchlistStatus status) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    final existingItem = currentItems.where(
      (WatchlistItem i) => i.movieId == movieId,
    ).firstOrNull;
    if (existingItem == null) return;

    final updated = existingItem.copyWith(
      status: status,
      updatedAt: DateTime.now(),
      watchedAt: status == WatchlistStatus.watched ? DateTime.now() : null,
    );

    final updatedItems = currentItems.map((i) {
      return i.movieId == movieId ? updated : i;
    }).toList();
    state = AsyncValue.data(updatedItems);

    try {
      await _repository.updateItem(updated);
    } catch (e) {
      state = AsyncValue.data(currentItems);
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    final existingItem = currentItems.where(
      (WatchlistItem i) => i.movieId == movieId,
    ).firstOrNull;
    if (existingItem != null) {
      final updated = existingItem.copyWith(
        isFavorite: !existingItem.isFavorite,
        updatedAt: DateTime.now(),
      );

      final updatedItems = currentItems.map((i) {
        return i.movieId == movieId ? updated : i;
      }).toList();
      state = AsyncValue.data(updatedItems);

      try {
        await _repository.updateItem(updated);
      } catch (e) {
        state = AsyncValue.data(currentItems);
      }
    }
  }

  Future<void> removeFromWatchlist(int movieId) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    final updatedItems = currentItems.where(
      (WatchlistItem i) => i.movieId != movieId,
    ).toList();
    state = AsyncValue.data(updatedItems);

    try {
      await _repository.removeItem(movieId);
    } catch (e) {
      state = AsyncValue.data(currentItems);
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  void syncWithUser(String? userId) {
    _userId = userId;
    _repository.setCurrentUser(userId);
    _load();
  }
}

enum WatchlistViewMode { all, planToWatch, stillWatching, watched }

final watchlistViewModeProvider = StateProvider<WatchlistViewMode>(
  (ref) => WatchlistViewMode.all,
);

enum WatchlistSortMode { addedDateDesc, addedDateAsc, rating, title }

final watchlistSortModeProvider = StateProvider<WatchlistSortMode>(
  (ref) => WatchlistSortMode.addedDateDesc,
);

final sortedWatchlistProvider = Provider<AsyncValue<List<WatchlistItem>>>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  final sortMode = ref.watch(watchlistSortModeProvider);

  return watchlist.whenData((List<WatchlistItem> items) {
    final sorted = List<WatchlistItem>.from(items);
    switch (sortMode) {
      case WatchlistSortMode.addedDateDesc:
        sorted.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      case WatchlistSortMode.addedDateAsc:
        sorted.sort((a, b) => a.addedAt.compareTo(b.addedAt));
      case WatchlistSortMode.rating:
        sorted.sort((a, b) => b.movie.voteAverage.compareTo(a.movie.voteAverage));
      case WatchlistSortMode.title:
        sorted.sort((a, b) => a.movie.title.compareTo(b.movie.title));
    }
    return sorted;
  });
});

final sortedFilteredWatchlistProvider = Provider<AsyncValue<List<WatchlistItem>>>((ref) {
  final viewMode = ref.watch(watchlistViewModeProvider);
  final sorted = ref.watch(sortedWatchlistProvider);

  return sorted.whenData((List<WatchlistItem> items) {
    switch (viewMode) {
      case WatchlistViewMode.all:
        return items;
      case WatchlistViewMode.planToWatch:
        return items.where(
          (WatchlistItem item) => item.status == WatchlistStatus.planToWatch,
        ).toList();
      case WatchlistViewMode.stillWatching:
        return items.where(
          (WatchlistItem item) => item.status == WatchlistStatus.stillWatching,
        ).toList();
      case WatchlistViewMode.watched:
        return items.where(
          (WatchlistItem item) => item.status == WatchlistStatus.watched,
        ).toList();
    }
  });
});



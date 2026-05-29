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
      final user = ref.watch(currentUserProvider);
<<<<<<< HEAD
      return WatchlistNotifier(repository, user?.id);
=======
      final notifier = WatchlistNotifier(repository, user?.id);

      ref.listen(currentUserProvider, (previous, next) {
        if (previous?.id != next?.id) {
          notifier.syncWithUser(next?.id);
        }
      });

      return notifier;
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    });

class WatchlistNotifier extends StateNotifier<AsyncValue<List<WatchlistItem>>> {
  final WatchlistRepository _repository;
  final String? _userId;

  WatchlistNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading()) {
<<<<<<< HEAD
    _setUser();
=======
    _repository.setCurrentUser(_userId);
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    _load();
  }

  void _setUser() {
    if (_userId != null) {
      (_repository as dynamic).setCurrentUser(_userId);
    }
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
<<<<<<< HEAD
      _setUser();
=======
      _repository.setCurrentUser(_userId);
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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
    state = AsyncValue.data([item, ...currentItems]);

    try {
      await _repository.addItem(item);
    } catch (e) {
      state = AsyncValue.data(currentItems);
      rethrow;
    }
  }

  Future<void> updateStatus(int movieId, WatchlistStatus status) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    final item = await _repository.getItem(movieId);
    if (item != null) {
      final updated = item.copyWith(
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
        rethrow;
      }
    }
  }

  Future<void> updateRating(int movieId, double rating) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    final existingItem = currentItems.where(
      (WatchlistItem i) => i.movieId == movieId,
    ).firstOrNull;
    if (existingItem != null) {
      final updated = existingItem.copyWith(
        userRating: rating,
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
        rethrow;
      }
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
        rethrow;
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
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  void syncWithUser(String? userId) {
    _repository.setCurrentUser(userId);
    _load();
  }
}

final watchlistByStatusProvider =
    Provider.family<AsyncValue<List<WatchlistItem>>, WatchlistStatus>((
      ref,
      status,
    ) {
      final watchlist = ref.watch(watchlistProvider);
      return watchlist.whenData(
        (List<WatchlistItem> items) =>
            items.where((WatchlistItem item) => item.status == status).toList(),
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

  return watchlist.whenData((List<WatchlistItem> items) {
    switch (viewMode) {
      case WatchlistViewMode.all:
        return items;
      case WatchlistViewMode.planToWatch:
        return items
            .where(
              (WatchlistItem item) =>
                  item.status == WatchlistStatus.planToWatch,
            )
            .toList();
      case WatchlistViewMode.stillWatching:
        return items
            .where(
              (WatchlistItem item) =>
                  item.status == WatchlistStatus.stillWatching,
            )
            .toList();
      case WatchlistViewMode.watched:
        return items
            .where(
              (WatchlistItem item) => item.status == WatchlistStatus.watched,
            )
            .toList();
    }
  });
});

final watchlistCountProvider = Provider<int>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.whenOrNull(data: (items) => items.length) ?? 0;
});

final favoritesCountProvider = Provider<int>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.whenOrNull(
        data: (items) => items.where((i) => i.isFavorite).length,
      ) ??
      0;
});

final planToWatchCountProvider = Provider<int>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.whenOrNull(
        data: (items) =>
            items.where((i) => i.status == WatchlistStatus.planToWatch).length,
      ) ??
      0;
});

final stillWatchingCountProvider = Provider<int>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.whenOrNull(
        data: (items) => items
            .where((i) => i.status == WatchlistStatus.stillWatching)
            .length,
      ) ??
      0;
});

final watchedCountProvider = Provider<int>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.whenOrNull(
        data: (items) =>
            items.where((i) => i.status == WatchlistStatus.watched).length,
      ) ??
      0;
});

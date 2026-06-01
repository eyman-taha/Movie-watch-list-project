import '../entities/watchlist_item.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistItem>> getAllItems();
  Stream<List<WatchlistItem>> watchItems();
  Future<WatchlistItem?> getItem(int movieId);
  Future<void> addItem(WatchlistItem item);
  Future<void> updateItem(WatchlistItem item);
  Future<void> removeItem(int movieId);
  Future<bool> isInWatchlist(int movieId);
  Future<List<WatchlistItem>> getItemsByStatus(WatchlistStatus status);
  Future<void> clearAll();
  void setCurrentUser(String? userId);
  String? get lastError;
  void clearError();
}

import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/watchlist_remote_datasource.dart';
import '../models/watchlist_item_model.dart';


class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource _localDataSource;
  final WatchlistRemoteDataSource? _remoteDataSource;
  String? _currentUserId;
  String? _lastError;

  WatchlistRepositoryImpl({
    required WatchlistLocalDataSource localDataSource,
    WatchlistRemoteDataSource? remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
  }

  @override
  String? get lastError => _lastError;

  @override
  void clearError() {
    _lastError = null;
  }

  @override
  Future<List<WatchlistItem>> getAllItems() async {
    _lastError = null;
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        final remoteModels = await _remoteDataSource.getUserWatchlist(
          _currentUserId!,
        );
        await _localDataSource.setAllItems(
          remoteModels.map((m) => _toMap(m)).toList(),
        );
        return remoteModels.map((m) => _toEntity(m)).toList();
      } catch (e) {
        _lastError = 'Firebase sync failed, using local data';
      }
    }
    final models = await _localDataSource.getAllItems();
    return models.map((m) => _toEntityFromModel(m)).toList();
  }

  @override
  Future<WatchlistItem?> getItem(int movieId) async {
    final model = await _localDataSource.getItem(movieId);
    return model != null ? _toEntityFromModel(model) : null;
  }

  @override
  Future<void> addItem(WatchlistItem item) async {
    _lastError = null;
    final model = WatchlistItemModel.fromEntity(item);
    await _localDataSource.addItem(_toMap(model));
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource.addToWatchlist(_currentUserId!, model);
      } catch (e) {
        _lastError = 'Failed to sync add to cloud';
      }
    }
  }

  @override
  Future<void> updateItem(WatchlistItem item) async {
    _lastError = null;
    final model = WatchlistItemModel.fromEntity(item);
    await _localDataSource.updateItem(_toMap(model));
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource.updateWatchlistItem(_currentUserId!, model);
      } catch (e) {
        _lastError = 'Failed to sync update to cloud';
      }
    }
  }

  @override
  Future<void> removeItem(int movieId) async {
    _lastError = null;
    await _localDataSource.removeItem(movieId);
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource.removeFromWatchlist(_currentUserId!, movieId);
      } catch (e) {
        _lastError = 'Failed to sync removal to cloud';
      }
    }
  }

  @override
  Future<bool> isInWatchlist(int movieId) async {
    return await _localDataSource.isInWatchlist(movieId);
  }

  @override
  Future<List<WatchlistItem>> getItemsByStatus(WatchlistStatus status) async {
    final models = await _localDataSource.getItemsByStatus(status.index);
    return models.map((m) => _toEntityFromModel(m)).toList();
  }

  @override
  Future<void> clearAll() async {
    _lastError = null;
    await _localDataSource.clearAll();
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource.clearUserWatchlist(_currentUserId!);
      } catch (e) {
        _lastError = 'Failed to clear cloud data';
      }
    }
  }

  WatchlistItem _toEntity(WatchlistItemModel model) {
    final movieModel = model.movie;
    return WatchlistItem(
      userId: model.userId,
      movieId: model.movieId,
      movie: Movie(
        id: movieModel.id,
        title: movieModel.title,
        originalTitle: movieModel.originalTitle,
        overview: movieModel.overview,
        posterPath: movieModel.posterPath,
        backdropPath: movieModel.backdropPath,
        releaseDate: movieModel.releaseDate,
        voteAverage: movieModel.voteAverage,
        voteCount: movieModel.voteCount,
        popularity: movieModel.popularity,
        genreIds: movieModel.genreIds,
        adult: movieModel.adult,
        originalLanguage: movieModel.originalLanguage,
      ),
      status: WatchlistStatus.values[model.statusIndex],
      userRating: model.userRating,
      isFavorite: model.isFavorite,
      addedAt: model.addedAt,
      updatedAt: model.updatedAt,
      watchedAt: model.watchedAt,
      note: model.note,
    );
  }

  WatchlistItem _toEntityFromModel(WatchlistItemModel model) {
    return WatchlistItem(
      userId: model.userId,
      movieId: model.movieId,
      movie: Movie(
        id: model.movie.id,
        title: model.movie.title,
        originalTitle: model.movie.originalTitle,
        overview: model.movie.overview,
        posterPath: model.movie.posterPath,
        backdropPath: model.movie.backdropPath,
        releaseDate: model.movie.releaseDate,
        voteAverage: model.movie.voteAverage,
        voteCount: model.movie.voteCount,
        popularity: model.movie.popularity,
        genreIds: model.movie.genreIds,
        adult: model.movie.adult,
        originalLanguage: model.movie.originalLanguage,
      ),
      status: WatchlistStatus.values[model.statusIndex],
      userRating: model.userRating,
      isFavorite: model.isFavorite,
      addedAt: model.addedAt,
      updatedAt: model.updatedAt,
      watchedAt: model.watchedAt,
      note: model.note,
    );
  }

  Map<String, dynamic> _toMap(WatchlistItemModel model) {
    final movieMap = model.movie;
    return {
      'userId': model.userId,
      'movieId': model.movieId,
      'movie': {
        'id': movieMap.id,
        'title': movieMap.title,
        'originalTitle': movieMap.originalTitle,
        'overview': movieMap.overview,
        'posterPath': movieMap.posterPath,
        'backdropPath': movieMap.backdropPath,
        'releaseDate': movieMap.releaseDate,
        'voteAverage': movieMap.voteAverage,
        'voteCount': movieMap.voteCount,
        'popularity': movieMap.popularity,
        'genreIds': movieMap.genreIds,
        'adult': movieMap.adult,
        'originalLanguage': movieMap.originalLanguage,
      },
      'statusIndex': model.statusIndex,
      'userRating': model.userRating,
      'isFavorite': model.isFavorite,
      'addedAt': model.addedAt.toIso8601String(),
      'updatedAt': model.updatedAt.toIso8601String(),
      'watchedAt': model.watchedAt?.toIso8601String(),
      'note': model.note,
    };
  }
}

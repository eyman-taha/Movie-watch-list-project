import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/watchlist_remote_datasource.dart';
import '../models/watchlist_item_model.dart';
import '../models/movie_model.dart';

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

  void setCurrentUser(String? userId) {
    _currentUserId = userId;
  }

  String? get lastError => _lastError;

  @override
  Future<List<WatchlistItem>> getAllItems() async {
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        final remoteModels = await _remoteDataSource!.getUserWatchlist(
          _currentUserId!,
        );
        if (remoteModels.isNotEmpty) {
          for (final model in remoteModels) {
            await _localDataSource.addItem(_toMap(model));
          }
          return remoteModels.map((m) => _toEntity(m)).toList();
        }
      } catch (e) {
        _lastError = 'Firebase sync failed, using local data';
      }
    }
    final models = await _localDataSource.getAllItems();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<WatchlistItem?> getItem(int movieId) async {
    final model = await _localDataSource.getItem(movieId);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> addItem(WatchlistItem item) async {
    final model = WatchlistItemModel.fromEntity(item);
    await _localDataSource.addItem(_toMap(model));
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource!.addToWatchlist(_currentUserId!, model);
      } catch (e) {
        _lastError = 'Failed to sync to cloud';
      }
    }
  }

  @override
  Future<void> updateItem(WatchlistItem item) async {
    final model = WatchlistItemModel.fromEntity(item);
    await _localDataSource.updateItem(_toMap(model));
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource!.updateWatchlistItem(_currentUserId!, model);
      } catch (e) {
        _lastError = 'Failed to sync update to cloud';
      }
    }
  }

  @override
  Future<void> removeItem(int movieId) async {
    await _localDataSource.removeItem(movieId);
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource!.removeFromWatchlist(_currentUserId!, movieId);
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
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<void> clearAll() async {
    await _localDataSource.clearAll();
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        final remoteModels = await _remoteDataSource!.getUserWatchlist(
          _currentUserId!,
        );
        for (final model in remoteModels) {
          await _remoteDataSource!.removeFromWatchlist(
            _currentUserId!,
            model.movieId,
          );
        }
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

  Map<String, dynamic> _toMap(WatchlistItemModel model) {
    final m = model.movie;
    return {
      'userId': model.userId,
      'movieId': model.movieId,
      'movie': {
        'id': m.id,
        'title': m.title,
        'originalTitle': m.originalTitle,
        'overview': m.overview,
        'posterPath': m.posterPath,
        'backdropPath': m.backdropPath,
        'releaseDate': m.releaseDate,
        'voteAverage': m.voteAverage,
        'voteCount': m.voteCount,
        'popularity': m.popularity,
        'genreIds': m.genreIds,
        'adult': m.adult,
        'originalLanguage': m.originalLanguage,
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

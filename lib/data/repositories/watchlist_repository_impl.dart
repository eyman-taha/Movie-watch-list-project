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

<<<<<<< HEAD
=======
  @override
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
  }

<<<<<<< HEAD
  String? get lastError => _lastError;

  @override
  Future<List<WatchlistItem>> getAllItems() async {
=======
  @override
  String? get lastError => _lastError;

  @override
  void clearError() {
    _lastError = null;
  }

  @override
  Future<List<WatchlistItem>> getAllItems() async {
    _lastError = null;
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        final remoteModels = await _remoteDataSource!.getUserWatchlist(
          _currentUserId!,
        );
<<<<<<< HEAD
        if (remoteModels.isNotEmpty) {
          for (final model in remoteModels) {
            await _localDataSource.addItem(_toMap(model));
          }
          return remoteModels.map((m) => _toEntity(m)).toList();
        }
=======
        await _localDataSource.clearAll();
        for (final model in remoteModels) {
          await _localDataSource.addItem(_toMap(model));
        }
        return remoteModels.map((m) => _toEntity(m)).toList();
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
      } catch (e) {
        _lastError = 'Firebase sync failed, using local data';
      }
    }
    final models = await _localDataSource.getAllItems();
<<<<<<< HEAD
    return models.map((m) => _toEntity(m)).toList();
=======
    return models.map((m) => _toEntityFromModel(m)).toList();
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
  }

  @override
  Future<WatchlistItem?> getItem(int movieId) async {
    final model = await _localDataSource.getItem(movieId);
    return model != null ? _toEntityFromModel(model) : null;
  }

  @override
  Future<void> addItem(WatchlistItem item) async {
<<<<<<< HEAD
=======
    _lastError = null;
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    final model = WatchlistItemModel.fromEntity(item);
    await _localDataSource.addItem(_toMap(model));
    if (_currentUserId != null && _remoteDataSource != null) {
      try {
        await _remoteDataSource!.addToWatchlist(_currentUserId!, model);
      } catch (e) {
<<<<<<< HEAD
        _lastError = 'Failed to sync to cloud';
=======
        _lastError = 'Failed to sync add to cloud';
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
      }
    }
  }

  @override
  Future<void> updateItem(WatchlistItem item) async {
<<<<<<< HEAD
=======
    _lastError = null;
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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
    _lastError = null;
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
<<<<<<< HEAD
    return models.map((m) => _toEntity(m)).toList();
=======
    return models.map((m) => _toEntityFromModel(m)).toList();
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
  }

  @override
  Future<void> clearAll() async {
    _lastError = null;
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

<<<<<<< HEAD
  Map<String, dynamic> _toMap(WatchlistItemModel model) {
    final m = model.movie;
=======
  WatchlistItem _toEntityFromModel(WatchlistItemModel model) {
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
    final movieMap = model.movie;
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    return {
      'userId': model.userId,
      'movieId': model.movieId,
      'movie': {
<<<<<<< HEAD
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
=======
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
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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

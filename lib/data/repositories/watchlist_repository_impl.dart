import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../models/watchlist_item_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource _localDataSource;

  WatchlistRepositoryImpl({required WatchlistLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<WatchlistItem>> getAllItems() async {
    final models = await _localDataSource.getAllItems();
    return models.map<WatchlistItem>((m) => _toEntity(m)).toList();
  }

  @override
  Future<WatchlistItem?> getItem(int movieId) async {
    final model = await _localDataSource.getItem(movieId);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> addItem(WatchlistItem item) async {
    await _localDataSource.addItem(_toModel(item));
  }

  @override
  Future<void> updateItem(WatchlistItem item) async {
    await _localDataSource.updateItem(_toModel(item));
  }

  @override
  Future<void> removeItem(int movieId) async {
    await _localDataSource.removeItem(movieId);
  }

  @override
  Future<bool> isInWatchlist(int movieId) async {
    return await _localDataSource.isInWatchlist(movieId);
  }

  @override
  Future<List<WatchlistItem>> getItemsByStatus(WatchlistStatus status) async {
    final models = await _localDataSource.getItemsByStatus(status.index);
    return models.map<WatchlistItem>((m) => _toEntity(m)).toList();
  }

  @override
  Future<void> clearAll() async {
    await _localDataSource.clearAll();
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

  Map<String, dynamic> _toModel(WatchlistItem item) {
    return {
      'userId': item.userId,
      'movieId': item.movieId,
      'movie': {
        'id': item.movie.id,
        'title': item.movie.title,
        'originalTitle': item.movie.originalTitle,
        'overview': item.movie.overview,
        'posterPath': item.movie.posterPath,
        'backdropPath': item.movie.backdropPath,
        'releaseDate': item.movie.releaseDate,
        'voteAverage': item.movie.voteAverage,
        'voteCount': item.movie.voteCount,
        'popularity': item.movie.popularity,
        'genreIds': item.movie.genreIds,
        'adult': item.movie.adult,
        'originalLanguage': item.movie.originalLanguage,
      },
      'statusIndex': item.status.index,
      'userRating': item.userRating,
      'isFavorite': item.isFavorite,
      'addedAt': item.addedAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
      'watchedAt': item.watchedAt?.toIso8601String(),
      'note': item.note,
    };
  }
}

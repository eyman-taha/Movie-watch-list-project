import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/movie_model.dart';
import '../../models/watchlist_item_model.dart';
import '../../models/genre_model.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheMovies(String key, List<MovieModel> movies);
  Future<List<MovieModel>?> getCachedMovies(String key);
  Future<void> cacheGenres(List<GenreModel> genres);
  Future<List<GenreModel>?> getCachedGenres();
  Future<void> clearCache();
  Future<void> clearCacheForKey(String key);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box<String> _moviesBox;
  final Box<String> _genresBox;

  MovieLocalDataSourceImpl({
    required Box<String> moviesBox,
    required Box<String> genresBox,
  }) : _moviesBox = moviesBox,
       _genresBox = genresBox;

  @override
  Future<void> cacheMovies(String key, List<MovieModel> movies) async {
    final jsonList = movies.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _moviesBox.put(key, jsonString);
  }

  @override
  Future<List<MovieModel>?> getCachedMovies(String key) async {
    final jsonString = _moviesBox.get(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genres) async {
    final jsonList = genres.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _genresBox.put('all_genres', jsonString);
  }

  @override
  Future<List<GenreModel>?> getCachedGenres() async {
    final jsonString = _genresBox.get('all_genres');
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await _moviesBox.clear();
    await _genresBox.clear();
  }

  @override
  Future<void> clearCacheForKey(String key) async {
    await _moviesBox.delete(key);
  }
}

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistItemModel>> getAllItems();
  Future<WatchlistItemModel?> getItem(int movieId);
  Future<void> addItem(Map<String, dynamic> item);
  Future<void> updateItem(Map<String, dynamic> item);
  Future<void> removeItem(int movieId);
  Future<bool> isInWatchlist(int movieId);
  Future<List<WatchlistItemModel>> getItemsByStatus(int statusIndex);
  Future<void> clearAll();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final Box<WatchlistItemModel> _watchlistBox;

  WatchlistLocalDataSourceImpl({required Box<WatchlistItemModel> watchlistBox})
    : _watchlistBox = watchlistBox;

  @override
  Future<List<WatchlistItemModel>> getAllItems() async {
    return _watchlistBox.values.toList();
  }

  @override
  Future<WatchlistItemModel?> getItem(int movieId) async {
    return _watchlistBox.get(movieId);
  }

  @override
  Future<void> addItem(Map<String, dynamic> item) async {
    final model = _mapToModel(item);
    await _watchlistBox.put(model.movieId, model);
  }

  @override
  Future<void> updateItem(Map<String, dynamic> item) async {
    final model = _mapToModel(item);
    await _watchlistBox.put(model.movieId, model);
  }

  @override
  Future<void> removeItem(int movieId) async {
    await _watchlistBox.delete(movieId);
  }

  @override
  Future<bool> isInWatchlist(int movieId) async {
    return _watchlistBox.containsKey(movieId);
  }

  @override
  Future<List<WatchlistItemModel>> getItemsByStatus(int statusIndex) async {
    return _watchlistBox.values
        .where((WatchlistItemModel item) => item.statusIndex == statusIndex)
        .toList();
  }

  @override
  Future<void> clearAll() async {
    await _watchlistBox.clear();
  }

  WatchlistItemModel _mapToModel(Map<String, dynamic> map) {
    return WatchlistItemModel(
      userId: map['userId'] as String?,
      movieId: map['movieId'] as int,
      movie: MovieModel(
        id: (map['movie'] as Map<String, dynamic>)['id'] as int,
        title: (map['movie'] as Map<String, dynamic>)['title'] as String,
        originalTitle:
            (map['movie'] as Map<String, dynamic>)['originalTitle'] as String,
        overview: (map['movie'] as Map<String, dynamic>)['overview'] as String,
        posterPath:
            (map['movie'] as Map<String, dynamic>)['posterPath'] as String?,
        backdropPath:
            (map['movie'] as Map<String, dynamic>)['backdropPath'] as String?,
        releaseDate:
            (map['movie'] as Map<String, dynamic>)['releaseDate'] as String,
        voteAverage:
            ((map['movie'] as Map<String, dynamic>)['voteAverage'] as num)
                .toDouble(),
        voteCount: (map['movie'] as Map<String, dynamic>)['voteCount'] as int,
        popularity:
            ((map['movie'] as Map<String, dynamic>)['popularity'] as num)
                .toDouble(),
        genreIds: ((map['movie'] as Map<String, dynamic>)['genreIds'] as List)
            .cast<int>(),
        adult: (map['movie'] as Map<String, dynamic>)['adult'] as bool,
        originalLanguage:
            (map['movie'] as Map<String, dynamic>)['originalLanguage']
                as String?,
      ),
      statusIndex: map['statusIndex'] as int,
      userRating: map['userRating'] as double?,
      isFavorite: map['isFavorite'] as bool,
      addedAt: DateTime.parse(map['addedAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      watchedAt: map['watchedAt'] != null
          ? DateTime.parse(map['watchedAt'] as String)
          : null,
      note: map['note'] as String?,
    );
  }
}

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> addSearch(String query);
  Future<void> removeSearch(String query);
  Future<void> clearHistory();
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  final Box<String> _searchBox;

  SearchHistoryLocalDataSourceImpl({required Box<String> searchBox})
    : _searchBox = searchBox;

  @override
  Future<List<String>> getSearchHistory() async {
    final jsonString = _searchBox.get('history');
    if (jsonString == null) return [];
    try {
      final List<dynamic> history = jsonDecode(jsonString);
      return history.cast<String>();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addSearch(String query) async {
    final history = await getSearchHistory();
    history.remove(query);
    history.insert(0, query);
    if (history.length > AppConstants.maxSearchHistory) {
      history.removeLast();
    }
    await _searchBox.put('history', jsonEncode(history));
  }

  @override
  Future<void> removeSearch(String query) async {
    final history = await getSearchHistory();
    history.remove(query);
    await _searchBox.put('history', jsonEncode(history));
  }

  @override
  Future<void> clearHistory() async {
    await _searchBox.put('history', jsonEncode(<String>[]));
  }
}

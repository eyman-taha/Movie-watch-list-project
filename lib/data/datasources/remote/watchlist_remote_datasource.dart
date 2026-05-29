import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/watchlist_item_model.dart';
import '../../models/movie_model.dart';

abstract class WatchlistRemoteDataSource {
  Future<List<WatchlistItemModel>> getUserWatchlist(String userId);
  Future<void> addToWatchlist(String userId, WatchlistItemModel item);
  Future<void> updateWatchlistItem(String userId, WatchlistItemModel item);
  Future<void> removeFromWatchlist(String userId, int movieId);
}

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final FirebaseFirestore _firestore;

  WatchlistRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _getRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('watchlist');
  }

  @override
  Future<List<WatchlistItemModel>> getUserWatchlist(String userId) async {
    final snapshot = await _getRef(userId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return WatchlistItemModel(
        userId: data['userId'] as String?,
        movieId: data['movieId'] as int,
        movie: _movieFromMap(data['movie'] as Map<String, dynamic>),
        statusIndex: data['statusIndex'] as int,
        userRating: data['userRating'] as double?,
        isFavorite: data['isFavorite'] as bool? ?? false,
        addedAt: DateTime.parse(data['addedAt'] as String),
        updatedAt: DateTime.parse(data['updatedAt'] as String),
        watchedAt: data['watchedAt'] != null
            ? DateTime.parse(data['watchedAt'] as String)
            : null,
        note: data['note'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> addToWatchlist(String userId, WatchlistItemModel item) async {
    await _getRef(userId).doc(item.movieId.toString()).set({
      'userId': item.userId,
      'movieId': item.movieId,
      'movie': _movieToMap(item.movie),
      'statusIndex': item.statusIndex,
      'userRating': item.userRating,
      'isFavorite': item.isFavorite,
      'addedAt': item.addedAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
      'watchedAt': item.watchedAt?.toIso8601String(),
      'note': item.note,
    });
  }

  @override
  Future<void> updateWatchlistItem(
      String userId, WatchlistItemModel item) async {
    await _getRef(userId).doc(item.movieId.toString()).update({
      'statusIndex': item.statusIndex,
      'userRating': item.userRating,
      'isFavorite': item.isFavorite,
      'updatedAt': DateTime.now().toIso8601String(),
      'watchedAt': item.watchedAt?.toIso8601String(),
      'note': item.note,
    });
  }

  @override
  Future<void> removeFromWatchlist(String userId, int movieId) async {
    await _getRef(userId).doc(movieId.toString()).delete();
  }

  MovieModel _movieFromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as int,
      title: map['title'] as String,
      originalTitle: map['originalTitle'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: map['posterPath'] as String?,
      backdropPath: map['backdropPath'] as String?,
      releaseDate: map['release_date'] as String? ?? map['releaseDate'] as String? ?? '',
      voteAverage: ((map['vote_average'] as num?) ?? (map['voteAverage'] as num?) ?? 0).toDouble(),
      voteCount: (map['vote_count'] as int?) ?? (map['voteCount'] as int?) ?? 0,
      popularity: ((map['popularity'] as num?) ?? 0).toDouble(),
      genreIds: (map['genre_ids'] as List?)?.cast<int>() ??
          (map['genreIds'] as List?)?.cast<int>() ?? [],
      adult: map['adult'] as bool? ?? false,
      originalLanguage: map['original_language'] as String? ??
          map['originalLanguage'] as String?,
    );
  }

  Map<String, dynamic> _movieToMap(MovieModel movie) {
    return {
      'id': movie.id,
      'title': movie.title,
      'originalTitle': movie.originalTitle,
      'overview': movie.overview,
      'posterPath': movie.posterPath,
      'backdropPath': movie.backdropPath,
      'releaseDate': movie.releaseDate,
      'voteAverage': movie.voteAverage,
      'voteCount': movie.voteCount,
      'popularity': movie.popularity,
      'genreIds': movie.genreIds,
      'adult': movie.adult,
      'originalLanguage': movie.originalLanguage,
    };
  }
}

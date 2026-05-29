import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import '../../models/watchlist_item_model.dart';
import '../../models/movie_model.dart';
=======
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/watchlist_item_model.dart';
import '../../models/movie_model.dart';
import '../../../presentation/providers/auth_providers.dart';
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)

abstract class WatchlistRemoteDataSource {
  Future<List<WatchlistItemModel>> getUserWatchlist(String userId);
  Future<void> addToWatchlist(String userId, WatchlistItemModel item);
  Future<void> updateWatchlistItem(String userId, WatchlistItemModel item);
  Future<void> removeFromWatchlist(String userId, int movieId);
<<<<<<< HEAD
=======
  Future<void> clearUserWatchlist(String userId);
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
}

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final FirebaseFirestore _firestore;
<<<<<<< HEAD

  WatchlistRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _getRef(String userId) {
=======
  final fb_auth.FirebaseAuth _auth;

  WatchlistRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required fb_auth.FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  CollectionReference<Map<String, dynamic>> _getUserWatchlistRef(
    String userId,
  ) {
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
    return _firestore.collection('users').doc(userId).collection('watchlist');
  }

  @override
  Future<List<WatchlistItemModel>> getUserWatchlist(String userId) async {
<<<<<<< HEAD
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
=======
    try {
      final snapshot = await _getUserWatchlistRef(userId).get();
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
    } catch (e) {
      return [];
    }
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
  }

  @override
  Future<void> addToWatchlist(String userId, WatchlistItemModel item) async {
<<<<<<< HEAD
    await _getRef(userId).doc(item.movieId.toString()).set({
=======
    await _getUserWatchlistRef(userId).doc(item.movieId.toString()).set({
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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
<<<<<<< HEAD
      String userId, WatchlistItemModel item) async {
    await _getRef(userId).doc(item.movieId.toString()).update({
=======
    String userId,
    WatchlistItemModel item,
  ) async {
    await _getUserWatchlistRef(userId).doc(item.movieId.toString()).update({
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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
<<<<<<< HEAD
    await _getRef(userId).doc(movieId.toString()).delete();
=======
    await _getUserWatchlistRef(userId).doc(movieId.toString()).delete();
  }

  @override
  Future<void> clearUserWatchlist(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _getUserWatchlistRef(userId).get();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
  }

  MovieModel _movieFromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as int,
      title: map['title'] as String,
      originalTitle: map['originalTitle'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterPath: map['posterPath'] as String?,
      backdropPath: map['backdropPath'] as String?,
<<<<<<< HEAD
      releaseDate: map['release_date'] as String? ?? map['releaseDate'] as String? ?? '',
      voteAverage: ((map['vote_average'] as num?) ?? (map['voteAverage'] as num?) ?? 0).toDouble(),
      voteCount: (map['vote_count'] as int?) ?? (map['voteCount'] as int?) ?? 0,
      popularity: ((map['popularity'] as num?) ?? 0).toDouble(),
      genreIds: (map['genre_ids'] as List?)?.cast<int>() ??
          (map['genreIds'] as List?)?.cast<int>() ?? [],
      adult: map['adult'] as bool? ?? false,
      originalLanguage: map['original_language'] as String? ??
          map['originalLanguage'] as String?,
=======
      releaseDate: map['releaseDate'] as String? ?? '',
      voteAverage: ((map['voteAverage'] as num?) ?? 0).toDouble(),
      voteCount: (map['voteCount'] as int?) ?? 0,
      popularity: ((map['popularity'] as num?) ?? 0).toDouble(),
      genreIds: (map['genreIds'] as List?)?.cast<int>() ?? [],
      adult: map['adult'] as bool? ?? false,
      originalLanguage: map['originalLanguage'] as String?,
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)
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
<<<<<<< HEAD
=======

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final watchlistRemoteDataSourceProvider = Provider<WatchlistRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return WatchlistRemoteDataSourceImpl(firestore: firestore, auth: auth);
});
>>>>>>> 9defcd7 (fix: convert all placeholder interactions to production-ready logic)

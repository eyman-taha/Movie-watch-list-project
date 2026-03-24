import 'package:hive/hive.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/entities/movie.dart';
import 'movie_model.dart';

part 'watchlist_item_model.g.dart';

@HiveType(typeId: 2)
class WatchlistItemModel extends WatchlistItem {
  @override
  @HiveField(0)
  final String? userId;
  
  @override
  @HiveField(1)
  final int movieId;
  
  @override
  @HiveField(2)
  final MovieModel movie;
  
  @HiveField(3)
  final int statusIndex;
  
  @override
  @HiveField(4)
  final double? userRating;
  
  @override
  @HiveField(5)
  final bool isFavorite;
  
  @override
  @HiveField(6)
  final DateTime addedAt;
  
  @override
  @HiveField(7)
  final DateTime updatedAt;
  
  @override
  @HiveField(8)
  final DateTime? watchedAt;
  
  @HiveField(9)
  final String? note;

  WatchlistItemModel({
    this.userId,
    required this.movieId,
    required this.movie,
    required this.statusIndex,
    this.userRating,
    this.isFavorite = false,
    required this.addedAt,
    required this.updatedAt,
    this.watchedAt,
    this.note,
  }) : super(
          userId: userId,
          movieId: movieId,
          movie: movie,
          status: WatchlistStatus.values[statusIndex],
          userRating: userRating,
          isFavorite: isFavorite,
          addedAt: addedAt,
          updatedAt: updatedAt,
          watchedAt: watchedAt,
          note: note,
        );

  factory WatchlistItemModel.fromEntity(WatchlistItem item) {
    return WatchlistItemModel(
      userId: item.userId,
      movieId: item.movieId,
      movie: MovieModel.fromEntity(item.movie),
      statusIndex: item.status.index,
      userRating: item.userRating,
      isFavorite: item.isFavorite,
      addedAt: item.addedAt,
      updatedAt: item.updatedAt,
      watchedAt: item.watchedAt,
      note: item.note,
    );
  }

  @override
  WatchlistItemModel copyWith({
    String? userId,
    int? movieId,
    Movie? movie,
    WatchlistStatus? status,
    double? userRating,
    bool? isFavorite,
    DateTime? addedAt,
    DateTime? updatedAt,
    DateTime? watchedAt,
    String? note,
  }) {
    return WatchlistItemModel(
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      movie: movie != null ? MovieModel.fromEntity(movie) : this.movie,
      statusIndex: status?.index ?? WatchlistStatus.values.indexOf(this.status),
      userRating: userRating ?? this.userRating,
      isFavorite: isFavorite ?? this.isFavorite,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      watchedAt: watchedAt ?? this.watchedAt,
      note: note ?? this.note,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'movie.dart';

enum WatchlistStatus {
  planToWatch,
  stillWatching,
  watched;

  String get displayName {
    switch (this) {
      case WatchlistStatus.planToWatch:
        return 'Plan to Watch';
      case WatchlistStatus.stillWatching:
        return 'Still Watching';
      case WatchlistStatus.watched:
        return 'Watched';
    }
  }

  String get shortName {
    switch (this) {
      case WatchlistStatus.planToWatch:
        return 'Plan';
      case WatchlistStatus.stillWatching:
        return 'Watching';
      case WatchlistStatus.watched:
        return 'Watched';
    }
  }

  static WatchlistStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'plantowatch':
      case 'plan':
        return WatchlistStatus.planToWatch;
      case 'stillwatching':
      case 'watching':
        return WatchlistStatus.stillWatching;
      case 'watched':
      case 'completed':
        return WatchlistStatus.watched;
      default:
        return WatchlistStatus.planToWatch;
    }
  }
}

class WatchlistItem extends Equatable {
  final String? userId;
  final int movieId;
  final Movie movie;
  final WatchlistStatus status;
  final double? userRating;
  final bool isFavorite;
  final DateTime addedAt;
  final DateTime updatedAt;
  final DateTime? watchedAt;
  final String? note;

  const WatchlistItem({
    this.userId,
    required this.movieId,
    required this.movie,
    required this.status,
    this.userRating,
    this.isFavorite = false,
    required this.addedAt,
    required this.updatedAt,
    this.watchedAt,
    this.note,
  });

  WatchlistItem copyWith({
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
    return WatchlistItem(
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      movie: movie ?? this.movie,
      status: status ?? this.status,
      userRating: userRating ?? this.userRating,
      isFavorite: isFavorite ?? this.isFavorite,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      watchedAt: watchedAt ?? this.watchedAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'movieId': movieId,
      'movie': movie,
      'status': status.name,
      'userRating': userRating,
      'isFavorite': isFavorite,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'watchedAt': watchedAt?.toIso8601String(),
      'note': note,
    };
  }

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      userId: json['userId'] as String?,
      movieId: json['movieId'] as int,
      movie: json['movie'] as Movie,
      status: WatchlistStatus.fromString(json['status'] as String),
      userRating: json['userRating'] as double?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      addedAt: DateTime.parse(json['addedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      watchedAt: json['watchedAt'] != null
          ? DateTime.parse(json['watchedAt'] as String)
          : null,
      note: json['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        movieId,
        movie,
        status,
        userRating,
        isFavorite,
        addedAt,
        updatedAt,
        watchedAt,
        note,
      ];
}

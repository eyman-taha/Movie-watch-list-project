import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/utils.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/watchlist_item.dart';
import '../../../domain/entities/movie_details.dart';
import '../../providers/movie_providers.dart';
import '../../providers/watchlist_providers.dart';
import '../../widgets/movie_card/movie_card.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailsAsync = ref.watch(movieDetailsProvider(movieId));
    final similarMoviesAsync = ref.watch(similarMoviesProvider(movieId));
    final watchlistAsync = ref.watch(watchlistProvider);

    return Scaffold(
      body: movieDetailsAsync.when(
        data: (movie) => _buildContent(
          context,
          ref,
          movie,
          similarMoviesAsync,
          watchlistAsync,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    MovieDetails movie,
    AsyncValue similarMoviesAsync,
    AsyncValue<List<WatchlistItem>> watchlistAsync,
  ) {
    final isInWatchlist =
        watchlistAsync.whenOrNull(
          data: (List<WatchlistItem> items) =>
              items.any((WatchlistItem item) => item.movieId == movie.id),
        ) ??
        false;

    final watchlistItem = watchlistAsync.whenOrNull(
      data: (List<WatchlistItem> items) => items.firstWhere(
        (WatchlistItem item) => item.movieId == movie.id,
        orElse: () => WatchlistItem(
          movieId: movie.id,
          movie: movie.toMovie(),
          status: WatchlistStatus.planToWatch,
          addedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );

    final isFavorite = watchlistItem?.isFavorite ?? false;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                movie.backdropPath != null
                    ? CachedNetworkImage(
                        imageUrl: ApiConstants.backdropUrl(movie.backdropPath),
                        fit: BoxFit.cover,
                      )
                    : Container(color: AppTheme.darkCard),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavorite),
                  color: isFavorite ? Colors.red : Colors.white,
                ),
              ),
              onPressed: () async {
                try {
                  if (isInWatchlist) {
                    await ref.read(watchlistProvider.notifier).toggleFavorite(movie.id);
                  } else {
                    await ref.read(watchlistProvider.notifier).addToWatchlist(movie.toMovie(), isFavorite: true);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isInWatchlist
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update favorites'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'movie_poster_${movie.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 120,
                          height: 180,
                          child: movie.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl: ApiConstants.posterUrl(
                                    movie.posterPath,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppTheme.darkCard,
                                  child: const Icon(Icons.movie, size: 40),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (movie.tagline != null &&
                              movie.tagline!.isNotEmpty)
                            Text(
                              movie.tagline!,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[400],
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildRatingBadge(movie.voteAverage),
                              const SizedBox(width: 12),
                              Text(
                                '${RatingUtils.formatVoteCount(movie.voteCount)} votes',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppDateUtils.formatDate(movie.releaseDate),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          if (movie.runtime != null)
                            Text(
                              StringUtils.formatRuntime(movie.runtime),
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildGenreChips(movie.genres.map((g) => g.name).toList()),
                const SizedBox(height: 24),
                _buildActionButtons(context, ref, movie, isInWatchlist, watchlistItem),
                const SizedBox(height: 24),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No overview available.',
                  style: TextStyle(color: Colors.grey[300], height: 1.5),
                ),
                if (movie.credits != null &&
                    movie.credits!.topCast.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Cast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCastSection(movie.credits!.topCast),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Similar Movies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        similarMoviesAsync.when(
              data: (movies) => movies.isEmpty
              ? const SliverToBoxAdapter(child: SizedBox.shrink())
              : SliverToBoxAdapter(
                  child: SimilarMoviesList(movies: movies),
                ),
          loading: () => const SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRatingColor(rating),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            RatingUtils.formatRating(rating),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChips(List<String> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres
          .map(
            (genre) => Chip(
              label: Text(genre),
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    MovieDetails movie,
    bool isInWatchlist,
    WatchlistItem? watchlistItem,
  ) {
    if (isInWatchlist && watchlistItem != null) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showStatusBottomSheet(
                      context, ref, movie, watchlistItem,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(watchlistItem.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _statusColor(watchlistItem.status)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_statusIcon(watchlistItem.status),
                              size: 18,
                              color: _statusColor(watchlistItem.status)),
                          const SizedBox(width: 8),
                          Text(
                            watchlistItem.status.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _statusColor(watchlistItem.status),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down,
                              size: 20,
                              color: _statusColor(watchlistItem.status)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openTrailer(context, movie),
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Trailer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showRemoveConfirm(context, ref, movie),
              icon: const Icon(Icons.delete_outline, size: 18,
                  color: Colors.red),
              label: const Text('Remove from Watchlist',
                  style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAddBottomSheet(context, ref, movie),
            icon: const Icon(Icons.add),
            label: const Text('Add to Watchlist'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _openTrailer(context, movie),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Trailer'),
          ),
        ),
      ],
    );
  }

  IconData _statusIcon(WatchlistStatus status) {
    switch (status) {
      case WatchlistStatus.planToWatch:
        return Icons.schedule;
      case WatchlistStatus.stillWatching:
        return Icons.play_circle;
      case WatchlistStatus.watched:
        return Icons.check_circle;
    }
  }

  Color _statusColor(WatchlistStatus status) {
    switch (status) {
      case WatchlistStatus.planToWatch:
        return Colors.orange;
      case WatchlistStatus.stillWatching:
        return Colors.blue;
      case WatchlistStatus.watched:
        return Colors.green;
    }
  }

  void _showStatusBottomSheet(
    BuildContext context,
    WidgetRef ref,
    MovieDetails movie,
    WatchlistItem item,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Change Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            for (final s in WatchlistStatus.values) ...[
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: s == item.status ? null : () async {
                      Navigator.pop(ctx);
                      try {
                        await ref
                            .read(watchlistProvider.notifier)
                            .updateStatus(movie.id, s);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Status: ${s.displayName}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update status'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _statusColor(s).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: s == item.status
                              ? _statusColor(s)
                              : _statusColor(s).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(_statusIcon(s), color: _statusColor(s)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(s.displayName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    if (s == item.status)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(Icons.check,
                                            size: 16, color: Colors.green),
                                      ),
                                  ],
                                ),
                                Text(
                                  _statusDescription(s),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddBottomSheet(BuildContext context, WidgetRef ref, MovieDetails movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Add to Watchlist',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            for (final s in WatchlistStatus.values) ...[
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(ctx);
                      try {
                        await ref
                            .read(watchlistProvider.notifier)
                            .addToWatchlist(movie.toMovie(), status: s);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${movie.title} added as ${s.displayName}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to add'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _statusColor(s).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _statusColor(s).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(_statusIcon(s), color: _statusColor(s)),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.displayName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(
                                _statusDescription(s),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  String _statusDescription(WatchlistStatus status) {
    switch (status) {
      case WatchlistStatus.planToWatch:
        return 'Movies you plan to watch in the future';
      case WatchlistStatus.stillWatching:
        return 'Movies you are currently watching';
      case WatchlistStatus.watched:
        return 'Movies you have already watched';
    }
  }

  void _showRemoveConfirm(
      BuildContext context, WidgetRef ref, MovieDetails movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.delete_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Remove from Watchlist?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      try {
                        await ref
                            .read(watchlistProvider.notifier)
                            .removeFromWatchlist(movie.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${movie.title} removed'),
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to remove'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openTrailer(BuildContext context, MovieDetails movie) {
    final trailer = movie.trailer;
    if (trailer == null || !trailer.isYouTube) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trailer available')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _TrailerBottomSheet(trailerKey: trailer.key),
    );
  }

  Widget _buildCastSection(List<dynamic> cast) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: member.profilePath != null
                        ? CachedNetworkImage(
                            imageUrl: ApiConstants.profileUrl(
                              member.profilePath,
                            ),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme.darkCard,
                            child: const Icon(Icons.person),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  member.character,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.grey[600]),
          const SizedBox(height: 16),
          const Text('Failed to load movie details'),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(movieDetailsProvider(movieId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.0) return Colors.green;
    if (rating >= 5.0) return Colors.orange;
    return Colors.red;
  }
}

class _TrailerBottomSheet extends StatefulWidget {
  final String trailerKey;

  const _TrailerBottomSheet({required this.trailerKey});

  @override
  State<_TrailerBottomSheet> createState() => _TrailerBottomSheetState();
}

class _TrailerBottomSheetState extends State<_TrailerBottomSheet> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trailer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFFE50914),
              progressColors: const ProgressBarColors(
                playedColor: Color(0xFFE50914),
                handleColor: Color(0xFFE50914),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SimilarMoviesList extends ConsumerWidget {
  final List<Movie> movies;

  const SimilarMoviesList({super.key, required this.movies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistAsync = ref.watch(watchlistProvider);
    final favoriteIds = watchlistAsync.whenOrNull(
          data: (items) => items
              .where((WatchlistItem i) => i.isFavorite)
              .map((WatchlistItem i) => i.movieId)
              .toSet(),
        ) ??
        <int>{};

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isFav = favoriteIds.contains(movie.id);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: MovieCard(
              movie: movie,
              height: 200,
              isFavorite: isFav,
              onToggleFavorite: (fav) async {
                if (isFav) {
                  await ref.read(watchlistProvider.notifier).toggleFavorite(movie.id);
                } else {
                  await ref.read(watchlistProvider.notifier).addToWatchlist(movie, isFavorite: true);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/utils.dart';
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
          data: (items) => items.any((item) => item.movieId == movie.id),
        ) ??
        false;

    final watchlistItem = watchlistAsync.whenOrNull(
      data: (items) => items.firstWhere(
        (item) => item.movieId == movie.id,
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
              onPressed: () {
                if (isInWatchlist) {
                  ref.read(watchlistProvider.notifier).toggleFavorite(movie.id);
                } else {
                  ref
                      .read(watchlistProvider.notifier)
                      .addToWatchlist(movie.toMovie(), isFavorite: true);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
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
                            DateUtils.formatDate(movie.releaseDate),
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
                _buildActionButtons(context, ref, movie, isInWatchlist),
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
                  child: SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: MovieCard(movie: movies[index], height: 200),
                        );
                      },
                    ),
                  ),
                ),
          loading: () => const SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
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
  ) {
    return Row(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isInWatchlist
                ? OutlinedButton.icon(
                    key: const ValueKey('remove'),
                    onPressed: () {
                      ref
                          .read(watchlistProvider.notifier)
                          .removeFromWatchlist(movie.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${movie.title} removed from watchlist',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('In Watchlist'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                  )
                : ElevatedButton.icon(
                    key: const ValueKey('add'),
                    onPressed: () {
                      ref
                          .read(watchlistProvider.notifier)
                          .addToWatchlist(movie.toMovie());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} added to watchlist'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Watchlist'),
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
    );
  }

  Future<void> _openTrailer(BuildContext context, MovieDetails movie) async {
    final trailer = movie.trailer;
    if (trailer != null && trailer.isYouTube) {
      final url = Uri.parse('https://www.youtube.com/watch?v=${trailer.key}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No trailer available')));
    }
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

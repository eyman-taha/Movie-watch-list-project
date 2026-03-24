import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/utils.dart';
import '../../../domain/entities/watchlist_item.dart';
import '../../providers/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(watchlistViewModeProvider);
    final watchlist = ref.watch(filteredWatchlistProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Watchlist',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusTabs(ref, viewMode),
                ],
              ),
            ),
            Expanded(
              child: watchlist.when(
                data: (items) => _buildWatchlistContent(context, ref, items),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    _buildErrorWidget(context, ref, error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTabs(WidgetRef ref, WatchlistViewMode viewMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab(ref, 'All', WatchlistViewMode.all, viewMode),
          const SizedBox(width: 8),
          _buildTab(
            ref,
            'Plan to Watch',
            WatchlistViewMode.planToWatch,
            viewMode,
          ),
          const SizedBox(width: 8),
          _buildTab(
            ref,
            'Still Watching',
            WatchlistViewMode.stillWatching,
            viewMode,
          ),
          const SizedBox(width: 8),
          _buildTab(ref, 'Watched', WatchlistViewMode.watched, viewMode),
        ],
      ),
    );
  }

  Widget _buildTab(
    WidgetRef ref,
    String label,
    WatchlistViewMode mode,
    WatchlistViewMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return GestureDetector(
      onTap: () {
        ref.read(watchlistViewModeProvider.notifier).state = mode;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlistContent(
    BuildContext context,
    WidgetRef ref,
    List<WatchlistItem> items,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(watchlistProvider.notifier).refresh();
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildWatchlistItem(context, ref, items[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWatchlistItem(
    BuildContext context,
    WidgetRef ref,
    WatchlistItem item,
  ) {
    return Dismissible(
      key: Key(item.movieId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(watchlistProvider.notifier).removeFromWatchlist(item.movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.movie.title} removed from watchlist'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(watchlistProvider.notifier).addToWatchlist(item.movie);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 70,
              height: 105,
              child: item.movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: ApiConstants.posterUrl(item.movie.posterPath),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie),
                    ),
            ),
          ),
          title: Text(
            item.movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusChip(item.status),
                  if (item.isFavorite) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.userRating != null
                        ? item.userRating!.toStringAsFixed(1)
                        : RatingUtils.formatRating(item.movie.voteAverage),
                    style: const TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'plantowatch':
                  ref
                      .read(watchlistProvider.notifier)
                      .updateStatus(item.movieId, WatchlistStatus.planToWatch);
                  break;
                case 'stillwatching':
                  ref
                      .read(watchlistProvider.notifier)
                      .updateStatus(
                        item.movieId,
                        WatchlistStatus.stillWatching,
                      );
                  break;
                case 'watched':
                  ref
                      .read(watchlistProvider.notifier)
                      .updateStatus(item.movieId, WatchlistStatus.watched);
                  break;
                case 'favorite':
                  ref
                      .read(watchlistProvider.notifier)
                      .toggleFavorite(item.movieId);
                  break;
                case 'remove':
                  ref
                      .read(watchlistProvider.notifier)
                      .removeFromWatchlist(item.movieId);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'plantowatch',
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: item.status == WatchlistStatus.planToWatch
                          ? AppTheme.primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Plan to Watch'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'stillwatching',
                child: Row(
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: item.status == WatchlistStatus.stillWatching
                          ? AppTheme.primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Still Watching'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'watched',
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: item.status == WatchlistStatus.watched
                          ? AppTheme.primaryColor
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Watched'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remove', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          onTap: () => context.push('/movie/${item.movieId}'),
        ),
      ),
    );
  }

  Widget _buildStatusChip(WatchlistStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case WatchlistStatus.planToWatch:
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case WatchlistStatus.stillWatching:
        color = Colors.blue;
        icon = Icons.play_arrow;
        break;
      case WatchlistStatus.watched:
        color = Colors.green;
        icon = Icons.check;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add movies to keep track of what you want to watch',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(watchlistProvider.notifier).refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

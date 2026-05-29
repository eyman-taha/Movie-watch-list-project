import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/utils.dart';
import '../../../domain/entities/watchlist_item.dart';
import '../../providers/watchlist_providers.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(watchlistViewModeProvider);
    final watchlist = ref.watch(filteredWatchlistProvider);
    final totalWatchlist = ref.watch(watchlistProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Watchlist',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        totalWatchlist.when(
                          data: (items) => _buildBadge(items.length),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your movies',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 20),
                    _buildStatusTabs(ref, viewMode),
                  ],
                ),
              ),
            ),
            Expanded(
              child: watchlist.when(
                data: (items) => _buildWatchlistContent(context, ref, items),
                loading: () => _buildLoadingState(),
                error: (error, _) =>
                    _buildErrorWidget(context, ref, error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bookmark, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            '$count movies',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs(WidgetRef ref, WatchlistViewMode viewMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab(ref, 'All', Icons.list, WatchlistViewMode.all, viewMode),
          const SizedBox(width: 8),
          _buildTab(
            ref,
            'Plan',
            Icons.schedule,
            WatchlistViewMode.planToWatch,
            viewMode,
          ),
          const SizedBox(width: 8),
          _buildTab(
            ref,
            'Watching',
            Icons.play_circle_outline,
            WatchlistViewMode.stillWatching,
            viewMode,
          ),
          const SizedBox(width: 8),
          _buildTab(
            ref,
            'Watched',
            Icons.check_circle_outline,
            WatchlistViewMode.watched,
            viewMode,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    WidgetRef ref,
    String label,
    IconData icon,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.darkCard,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
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
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(watchlistProvider.notifier).refresh();
      },
      color: AppTheme.primaryColor,
      backgroundColor: AppTheme.darkCard,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        try {
          await ref.read(watchlistProvider.notifier).removeFromWatchlist(item.movieId);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.movie.title} removed'),
                backgroundColor: AppTheme.darkCard,
                action: SnackBarAction(
                  label: 'Undo',
                  textColor: AppTheme.primaryColor,
                  onPressed: () {
                    ref.read(watchlistProvider.notifier).addToWatchlist(item.movie);
                  },
                ),
              ),
            );
          }
          return true;
        } catch (_) {
          return false;
        }
      },
      child: GestureDetector(
        onTap: () => context.push('/movie/${item.movieId}'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 80,
                  height: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      item.movie.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl: ApiConstants.posterUrl(
                                item.movie.posterPath,
                              ),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.movie, size: 30),
                            ),
                      if (item.isFavorite)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatusChip(item.status),
                          const Spacer(),
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
                                    : RatingUtils.formatRating(
                                        item.movie.voteAverage,
                                      ),
                                style: const TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppDateUtils.formatYear(item.movie.releaseDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                color: AppTheme.darkSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) => _handleMenuAction(ref, item, value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'plantowatch',
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: item.status == WatchlistStatus.planToWatch
                              ? AppTheme.primaryColor
                              : Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Plan to Watch',
                          style: TextStyle(
                            color: item.status == WatchlistStatus.planToWatch
                                ? AppTheme.primaryColor
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'stillwatching',
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 20,
                          color: item.status == WatchlistStatus.stillWatching
                              ? Colors.blue
                              : Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Still Watching',
                          style: TextStyle(
                            color: item.status == WatchlistStatus.stillWatching
                                ? Colors.blue
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'watched',
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: item.status == WatchlistStatus.watched
                              ? Colors.green
                              : Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Watched',
                          style: TextStyle(
                            color: item.status == WatchlistStatus.watched
                                ? Colors.green
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'favorite',
                    child: Row(
                      children: [
                        Icon(
                          item.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: item.isFavorite ? Colors.red : Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.isFavorite
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                          style: TextStyle(
                            color: item.isFavorite ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Remove', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(WidgetRef ref, WatchlistItem item, String value) {
    switch (value) {
      case 'plantowatch':
        ref
            .read(watchlistProvider.notifier)
            .updateStatus(item.movieId, WatchlistStatus.planToWatch);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.movie.title} → Plan to Watch'),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case 'stillwatching':
        ref
            .read(watchlistProvider.notifier)
            .updateStatus(item.movieId, WatchlistStatus.stillWatching);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.movie.title} → Still Watching'),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case 'watched':
        ref
            .read(watchlistProvider.notifier)
            .updateStatus(item.movieId, WatchlistStatus.watched);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.movie.title} → Watched'),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case 'favorite':
        ref.read(watchlistProvider.notifier).toggleFavorite(item.movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              item.isFavorite
                  ? '${item.movie.title} removed from favorites'
                  : '${item.movie.title} added to favorites',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case 'remove':
        ref.read(watchlistProvider.notifier).removeFromWatchlist(item.movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.movie.title} removed'),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
    }
  }

  Widget _buildStatusChip(WatchlistStatus status) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case WatchlistStatus.planToWatch:
        color = Colors.orange;
        icon = Icons.schedule;
        label = 'Plan';
        break;
      case WatchlistStatus.stillWatching:
        color = Colors.blue;
        icon = Icons.play_circle_outline;
        label = 'Watching';
        break;
      case WatchlistStatus.watched:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        label = 'Watched';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
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

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_outline,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Your Watchlist is Empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Start adding movies to your watchlist\nto keep track of what you want to watch.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/search'),
                icon: const Icon(Icons.search),
                label: const Text('Discover Movies'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(watchlistProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

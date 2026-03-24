import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/utils.dart';
import '../../../domain/entities/movie.dart';
import '../../providers/movie_providers.dart';
import '../../widgets/movie_card/movie_card.dart';
import '../../widgets/shimmer/shimmer_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(trendingMoviesProvider);
          ref.invalidate(popularMoviesProvider);
          ref.invalidate(topRatedMoviesProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.movie_filter,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'CineWatch',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: _buildTrendingSection()),
            SliverToBoxAdapter(child: _buildPopularSection()),
            SliverToBoxAdapter(child: _buildTopRatedSection()),
            SliverToBoxAdapter(child: _buildNowPlayingSection()),
            SliverToBoxAdapter(child: _buildUpcomingSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    final trendingAsync = ref.watch(trendingMoviesProvider);

    return trendingAsync.when(
      data: (movies) => _buildCarousel(movies),
      loading: () => SizedBox(
        height: 450,
        child: Center(child: MovieCardShimmer(width: 300, height: 450)),
      ),
      error: (error, _) => _buildErrorWidget(
        error.toString(),
        () => ref.invalidate(trendingMoviesProvider),
      ),
    );
  }

  Widget _buildPopularSection() {
    final moviesAsync = ref.watch(popularMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Popular Movies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        moviesAsync.when(
          data: (movies) => _buildMovieList(movies),
          loading: () => const MovieListShimmer(),
          error: (error, _) => _buildErrorWidget(
            error.toString(),
            () => ref.invalidate(popularMoviesProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildTopRatedSection() {
    final moviesAsync = ref.watch(topRatedMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Top Rated',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        moviesAsync.when(
          data: (movies) => _buildMovieList(movies),
          loading: () => const MovieListShimmer(),
          error: (error, _) => _buildErrorWidget(
            error.toString(),
            () => ref.invalidate(topRatedMoviesProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingSection() {
    final moviesAsync = ref.watch(nowPlayingMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Now Playing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        moviesAsync.when(
          data: (movies) => _buildMovieList(movies),
          loading: () => const MovieListShimmer(),
          error: (error, _) => _buildErrorWidget(
            error.toString(),
            () => ref.invalidate(nowPlayingMoviesProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    final moviesAsync = ref.watch(upcomingMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Upcoming',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        moviesAsync.when(
          data: (movies) => _buildMovieList(movies),
          loading: () => const MovieListShimmer(),
          error: (error, _) => _buildErrorWidget(
            error.toString(),
            () => ref.invalidate(upcomingMoviesProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox(height: 450);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Trending This Week',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 450,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildCarouselItem(movies[index], index);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            movies.length.clamp(0, 10),
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppTheme.primaryColor
                    : Colors.grey[600],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Movie movie, int index) {
    return ListenableBuilder(
      listenable: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index - (_pageController.page ?? 0);
          value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
        }
        return Center(
          child: Transform.scale(
            scale: value,
            child: GestureDetector(
              onTap: () => context.go('/movie/${movie.id}'),
              child: Hero(
                tag: 'trending_${movie.id}',
                child: Container(
                  height: 400,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        movie.backdropPath != null
                            ? CachedNetworkImage(
                                imageUrl: ApiConstants.backdropUrl(
                                  movie.backdropPath,
                                ),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: AppTheme.darkCard),
                                errorWidget: (context, url, error) => Container(
                                  color: AppTheme.darkCard,
                                  child: const Icon(Icons.movie, size: 60),
                                ),
                              )
                            : Container(
                                color: AppTheme.darkCard,
                                child: const Icon(Icons.movie, size: 60),
                              ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRatingColor(movie.voteAverage),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          RatingUtils.formatRating(
                                            movie.voteAverage,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    DateUtils.formatYear(movie.releaseDate),
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                StringUtils.truncate(movie.overview, 100),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
          ),
        );
      },
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 210,
        child: Center(child: Text('No movies found')),
      );
    }

    return AnimationLimiter(
      child: SizedBox(
        height: 210,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: MovieCard(movie: movies[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.grey[600], size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load movies',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.0) return Colors.green;
    if (rating >= 5.0) return Colors.orange;
    return Colors.red;
  }
}

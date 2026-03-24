import 'dart:async';

import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/genre.dart';
import '../../providers/providers.dart';
import '../../providers/movie_providers.dart';
import '../../widgets/movie_card/movie_card.dart';
import '../../widgets/shimmer/shimmer_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _recentSearches = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final history = await ref
          .read(searchHistoryDataSourceProvider)
          .getSearchHistory();
      setState(() {
        _recentSearches = history;
        _isLoadingHistory = false;
      });
    } catch (_) {
      setState(() {
        _recentSearches = [];
        _isLoadingHistory = false;
      });
    }
  }

  Future<void> _addToHistory(String query) async {
    if (query.isEmpty) return;

    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty) return;

    final updated = [
      cleanedQuery,
      ..._recentSearches.where((item) => item != cleanedQuery),
    ];
    if (updated.length > 10) {
      updated.removeRange(10, updated.length);
    }

    setState(() {
      _recentSearches = updated;
    });

    await ref.read(searchHistoryDataSourceProvider).addSearch(cleanedQuery);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  void _onSearchSubmitted(String query) {
    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty) return;

    _addToHistory(cleanedQuery);
    ref.read(searchQueryProvider.notifier).state = cleanedQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchMoviesProvider);
    final genres = ref.watch(genresProvider);
    final selectedGenre = ref.watch(selectedGenreProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Search movies...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(searchQueryProvider.notifier).state =
                                    '';
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  genres.when(
                    data: (genreList) =>
                        _buildGenreChips(genreList, selectedGenre),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: query.isEmpty
                  ? (_isLoadingHistory
                        ? const Center(child: CircularProgressIndicator())
                        : _buildRecentSearches())
                  : searchResults.when(
                      data: (movies) => _buildSearchResults(movies),
                      loading: () => const MovieGridShimmer(),
                      error: (error, _) => _buildErrorWidget(error.toString()),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChips(List<Genre> genres, Genre? selectedGenre) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedGenre == null,
            onSelected: (_) {
              ref.read(selectedGenreProvider.notifier).state = null;
            },
          ),
          const SizedBox(width: 8),
          ...genres.map(
            (genre) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(genre.name),
                selected: selectedGenre?.id == genre.id,
                onSelected: (_) {
                  ref.read(selectedGenreProvider.notifier).state =
                      selectedGenre?.id == genre.id ? null : genre;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'Search for movies',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Find your favorite movies',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
              child: const Text('Clear'),
            ),
          ],
        ),
        ...List.generate(
          _recentSearches.length,
          (index) => ListTile(
            leading: const Icon(Icons.history),
            title: Text(_recentSearches[index]),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _recentSearches.removeAt(index);
                });
              },
            ),
            onTap: () {
              _searchController.text = _recentSearches[index];
              ref.read(searchQueryProvider.notifier).state =
                  _recentSearches[index];
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 80, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No movies found',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: MovieCard(
                  movie: movies[index],
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
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
              ref.invalidate(searchMoviesProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

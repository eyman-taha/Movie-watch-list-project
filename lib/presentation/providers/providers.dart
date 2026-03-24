import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_client.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/movie_remote_datasource.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/watchlist_item_model.dart';
import '../../data/models/genre_model.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/watchlist_repository.dart';
import 'auth_providers.dart';

export 'auth_providers.dart';

final networkClientProvider = Provider<NetworkClient>((ref) {
  return NetworkClient();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return MovieRemoteDataSourceImpl(networkClient);
});

final movieLocalDataSourceProvider = Provider<MovieLocalDataSource>((ref) {
  throw UnimplementedError('Local data sources not initialized');
});

final watchlistLocalDataSourceProvider = Provider<WatchlistLocalDataSource>((
  ref,
) {
  throw UnimplementedError('Watchlist data source not initialized');
});

final searchHistoryDataSourceProvider = Provider<SearchHistoryLocalDataSource>((
  ref,
) {
  throw UnimplementedError('Search history data source not initialized');
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final remoteDataSource = ref.watch(movieRemoteDataSourceProvider);
  final localDataSource = ref.watch(movieLocalDataSourceProvider);
  return MovieRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  final localDataSource = ref.watch(watchlistLocalDataSourceProvider);
  return WatchlistRepositoryImpl(localDataSource: localDataSource);
});

class HiveBoxes {
  final Box<String> movies;
  final Box<String> genres;
  final Box<WatchlistItemModel> watchlist;
  final Box<String> searchHistory;

  HiveBoxes({
    required this.movies,
    required this.genres,
    required this.watchlist,
    required this.searchHistory,
  });
}

Future<HiveBoxes> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(GenreModelAdapter());
  Hive.registerAdapter(WatchlistItemModelAdapter());

  final moviesBox = await Hive.openBox<String>('movies_cache');
  final genresBox = await Hive.openBox<String>('genres_cache');
  final watchlistBox = await Hive.openBox<WatchlistItemModel>('watchlist');
  final searchHistoryBox = await Hive.openBox<String>('search_history');

  return HiveBoxes(
    movies: moviesBox,
    genres: genresBox,
    watchlist: watchlistBox,
    searchHistory: searchHistoryBox,
  );
}

Future<ProviderContainer> initProviders() async {
  final prefs = await SharedPreferences.getInstance();
  final hiveBoxes = await initHive();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      movieLocalDataSourceProvider.overrideWithValue(
        MovieLocalDataSourceImpl(
          moviesBox: hiveBoxes.movies,
          genresBox: hiveBoxes.genres,
        ),
      ),
      watchlistLocalDataSourceProvider.overrideWithValue(
        WatchlistLocalDataSourceImpl(watchlistBox: hiveBoxes.watchlist),
      ),
      searchHistoryDataSourceProvider.overrideWithValue(
        SearchHistoryLocalDataSourceImpl(searchBox: hiveBoxes.searchHistory),
      ),
    ],
  );

  return container;
}

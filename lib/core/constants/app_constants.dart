class AppConstants {
  AppConstants._();

  static const String appName = 'CineWatch';
  static const String appVersion = '1.0.0';
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  static const int maxSearchHistory = 10;
  static const Duration cacheExpiration = Duration(hours: 24);
  
  static const double cardBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double movieCardWidth = 140.0;
  static const double movieCardHeight = 210.0;
  static const double carouselItemWidth = 300.0;
  static const double carouselItemHeight = 450.0;
}

class HiveBoxes {
  HiveBoxes._();
  
  static const String movies = 'movies';
  static const String watchlist = 'watchlist';
  static const String searchHistory = 'search_history';
  static const String preferences = 'preferences';
  static const String genres = 'genres';
}

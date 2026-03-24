class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  
  static const String apiKey = 'b1ba167abb48cb8c14daa23abf034de3';
  
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';
  static const String originalSize = 'original';
  
  static String posterUrl(String? path) =>
      path != null ? '$imageBaseUrl/$posterSize$path' : '';
  
  static String backdropUrl(String? path) =>
      path != null ? '$imageBaseUrl/$backdropSize$path' : '';
  
  static String profileUrl(String? path) =>
      path != null ? '$imageBaseUrl/$profileSize$path' : '';
  
  static const int pageSize = 20;
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class ApiEndpoints {
  ApiEndpoints._();

  static const String trending = '/trending/movie/week';
  static const String popular = '/movie/popular';
  static const String topRated = '/movie/top_rated';
  static const String nowPlaying = '/movie/now_playing';
  static const String upcoming = '/movie/upcoming';
  static const String search = '/search/movie';
  static const String genres = '/genre/movie/list';
  
  static String movieDetails(int movieId) => '/movie/$movieId';
  static String movieCredits(int movieId) => '/movie/$movieId/credits';
  static String movieSimilar(int movieId) => '/movie/$movieId/similar';
  static String movieVideos(int movieId) => '/movie/$movieId/videos';
  static String movieRecommendations(int movieId) => '/movie/$movieId/recommendations';
  static String discoverMovies = '/discover/movie';
}

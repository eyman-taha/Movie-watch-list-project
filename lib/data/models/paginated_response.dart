import 'movie_model.dart';

class PaginatedResponse<T> {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<T> results;

  const PaginatedResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  bool get hasMore => page < totalPages;
}

class MovieListResponse extends PaginatedResponse<MovieModel> {
  const MovieListResponse({
    required super.page,
    required super.totalPages,
    required super.totalResults,
    required super.results,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      page: json['page'] as int,
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

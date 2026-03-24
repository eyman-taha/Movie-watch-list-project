import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';

class NetworkClient {
  late final Dio _dio;

  NetworkClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response?.statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure('Request cancelled');
      default:
        return const UnknownFailure('An unexpected error occurred');
    }
  }

  Failure _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 401:
        return const ApiKeyFailure();
      case 404:
        return const NotFoundFailure();
      case 429:
        return const RateLimitFailure();
      case 500:
      case 502:
      case 503:
        return const ServerFailure();
      default:
        return ServerFailure('Server error: $statusCode');
    }
  }
}

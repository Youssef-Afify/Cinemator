import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';
import 'tmdb_response.dart';

class MovieRepository {
  final String apiKey;
  final String baseUrl = 'https://api.themoviedb.org/3';
  static const int maxRetries = 3;

  MovieRepository({required this.apiKey});

  // ========== API Endpoints ==========

  /// Get popular movies
  Future<TmdbResponse> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/popular?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Get now playing movies
  Future<TmdbResponse> getNowPlaying({int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/now_playing?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Get upcoming movies
  Future<TmdbResponse> getUpcoming({int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/upcoming?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Get top rated movies
  Future<TmdbResponse> getTopRated({int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/top_rated?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Search movies by query
  Future<TmdbResponse> searchMovies(String query, {int page = 1}) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      '$baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Get detailed info for a specific movie
  Future<MovieModel> getMovieDetails(int movieId) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId?api_key=$apiKey',
    );
    
    final response = await _fetchWithRetry(() async {
      return await http.get(url);
    });

    if (response.statusCode != 200) {
      throw _handleError(response);
    }

    final data = json.decode(response.body);
    return MovieModel.fromJson(data);
  }

  /// Get similar movies for a specific movie
  Future<TmdbResponse> getSimilarMovies(int movieId, {int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId/similar?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  /// Get recommendations based on a movie
  Future<TmdbResponse> getRecommendations(int movieId, {int page = 1}) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId/recommendations?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  // ========== Cache Methods ==========

  // Simple in-memory cache
  final Map<String, CacheEntry> _cache = {};
  static const Duration cacheDuration = Duration(minutes: 30);

  Future<TmdbResponse> getWithCache(String key, Future<TmdbResponse> Function() fetch) async {
    // Check if cache is valid
    if (_cache.containsKey(key)) {
      final entry = _cache[key]!;
      if (DateTime.now().difference(entry.timestamp) < cacheDuration) {
        return entry.data;
      }
    }

    // Fetch fresh data
    final data = await fetch();
    _cache[key] = CacheEntry(data: data, timestamp: DateTime.now());
    return data;
  }

  void clearCache() {
    _cache.clear();
  }

  // ========== Private Methods ==========

  Future<TmdbResponse> _fetchResponse(Uri url) async {
    final response = await _fetchWithRetry(() async {
      return await http.get(url);
    });

    if (response.statusCode != 200) {
      throw _handleError(response);
    }

    final data = json.decode(response.body);
    return TmdbResponse.fromJson(data);
  }

  Future<http.Response> _fetchWithRetry(
    Future<http.Response> Function() fetch,
  ) async {
    int retries = 0;
    while (retries < maxRetries) {
      try {
        final response = await fetch();
        return response;
      } catch (e) {
        retries++;
        if (retries >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: retries * 2));
      }
    }
    throw Exception('Max retries exceeded');
  }

  Exception _handleError(http.Response response) {
    String message;
    switch (response.statusCode) {
      case 400:
        message = 'Bad request';
        break;
      case 401:
        message = 'Invalid API key';
        break;
      case 404:
        message = 'Resource not found';
        break;
      case 429:
        message = 'Too many requests. Please try again later.';
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = 'Failed to load data (${response.statusCode})';
    }
    return Exception(message);
  }
}

// Cache helper class
class CacheEntry {
  final TmdbResponse data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}
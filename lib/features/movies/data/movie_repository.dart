import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task/core/constants/enums.dart';
import '../../movie_details/data/movie_details_model.dart';
import 'tmdb_model.dart';

class MovieRepository {
  final String apiKey;
  final String baseUrl = 'https://api.themoviedb.org/3';
  static const int maxRetries = 3;

  MovieRepository({required this.apiKey});

  // ========== API Endpoints ==========

  Future<TmdbModel> getByCategory({
    int page = 1,
    required CategoryGet category,
  }) async {
    final url = Uri.parse(
      '$baseUrl/movie/${_getCategory(category)}?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  Future<TmdbModel> getForMovie(
    int movieId, {
    int page = 1,
    MovieGet movie = MovieGet.similar,
  }) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId/${movie.toString()}?api_key=$apiKey&page=$page',
    );
    return await _fetchResponse(url);
  }

  Future<TmdbModel> searchMovies(String query, {int page = 1}) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      '$baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery&page=$page',
    );
    return await _fetchResponse(url);
  }

  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final url = Uri.parse(
      '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,videos',
    );

    final response = await _fetchWithRetry(() async {
      return await http.get(url);
    });

    if (response.statusCode != 200) {
      throw _handleError(response);
    }

    final data = json.decode(response.body);
    return MovieDetailsModel.fromJson(data);
  }

  Future<TmdbModel> getMoviesByGenre({
    required int genreId,
    int page = 1,
  }) async {
    final url = Uri.parse(
      '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&page=$page',
    );
    return await _fetchResponse(url);
  }

  // ========== Cache Methods ==========

  // Simple in-memory cache
  final Map<String, CacheEntry> _cache = {};
  static const Duration cacheDuration = Duration(minutes: 30);

  Future<TmdbModel> getWithCache(
    String key,
    Future<TmdbModel> Function() fetch,
  ) async {
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

  String _getCategory(CategoryGet category) {
    switch (category) {
      case CategoryGet.popular:
        return 'popular';
      case CategoryGet.nowPlaying:
        return 'now_playing';
      case CategoryGet.upcoming:
        return 'upcoming';
      case CategoryGet.topRated:
        return 'top_rated';
    }
  }

  Future<TmdbModel> _fetchResponse(Uri url) async {
    final response = await _fetchWithRetry(() async {
      return await http.get(url);
    });

    if (response.statusCode != 200) {
      throw _handleError(response);
    }

    final data = json.decode(response.body);
    return TmdbModel.fromJson(data);
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
  final TmdbModel data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}
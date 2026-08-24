import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task/features/genres/data/genre_model.dart';

class GenreRepository {
  final String apiKey;
  final String baseUrl = 'https://api.themoviedb.org/3';
  static const int maxRetries = 3;

  GenreRepository({required this.apiKey});

  // ========== API Endpoints ==========

  Future<List<GenreModel>> getAll() async {
    final url = Uri.parse(
      '$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US',
    );
    return await _fetchResponse(url);
  }

  // ========== Cache Methods ==========

  final Map<String, CacheEntry> _cache = {};
  static const Duration cacheDuration = Duration(minutes: 30);

  Future<List<GenreModel>> getWithCache(
    String key,
    Future<List<GenreModel>> Function() fetch,
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

  Future<List<GenreModel>> _fetchResponse(Uri url) async {
    final response = await _fetchWithRetry(() async {
      return await http.get(url);
    });

    if (response.statusCode != 200) {
      throw _handleError(response);
    }

    final data = json.decode(response.body);

    final List<dynamic> genresList = data['genres'] ?? [];
    if (genresList.isEmpty) {
      return [];
    }

    return List.generate(
      genresList.length,
      (index) => GenreModel.fromJson(genresList[index]),
    );
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
  final List<GenreModel> data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}
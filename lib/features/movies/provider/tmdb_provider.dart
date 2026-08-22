import 'package:flutter/material.dart';
import '../data/movie_model.dart';
import '../data/movie_repository.dart';

class TmdbProvider extends ChangeNotifier {
  final MovieRepository repository;
  
  List<MovieModel> movies = [];
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 1;
  bool hasMorePages = true;

  TmdbProvider({required this.repository});

  Future<void> fetchPopularMovies({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      movies.clear();
      hasMorePages = true;
    }

    if (!hasMorePages || isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.getPopularMovies(page: currentPage);
      movies.addAll(response.results);
      hasMorePages = currentPage < response.totalPages;
      currentPage++;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      await fetchPopularMovies(refresh: true);
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.searchMovies(query);
      movies = response.results;
      hasMorePages = false;
    } catch (e) {
      errorMessage = e.toString();
      movies.clear();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<MovieModel?> getMovieDetails(int id) async {
    try {
      return await repository.getMovieDetails(id);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
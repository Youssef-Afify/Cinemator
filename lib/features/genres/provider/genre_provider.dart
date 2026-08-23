import 'package:flutter/material.dart';
import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/genres/data/genre_repository.dart';

class GenreProvider extends ChangeNotifier {
  final GenreRepository repository;

  List<GenreModel> genres = [];
  bool isLoading = false;
  String? errorMessage;

  GenreProvider({required this.repository});

  Future<void> loadGenres({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      repository.clearCache();
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      genres = await repository.getWithCache('all_genres', repository.getAll);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:task/features/movies/data/movie_model.dart';

class FavoritesProvider extends ChangeNotifier {
  // Keyed by movie id so add/remove/lookup are all O(1) and a movie can
  // never end up duplicated in the list.
  final Map<int, MovieModel> _favorites = {};

  List<MovieModel> get favorites => _favorites.values.toList();

  bool isFavorite(int movieId) => _favorites.containsKey(movieId);

  void addFavorite(MovieModel movie) {
    if (_favorites.containsKey(movie.id)) return;
    _favorites[movie.id] = movie;
    notifyListeners();
  }

  void removeFavorite(int movieId) {
    if (!_favorites.containsKey(movieId)) return;
    _favorites.remove(movieId);
    notifyListeners();
  }

  void toggleFavorite(MovieModel movie) {
    if (isFavorite(movie.id)) {
      removeFavorite(movie.id);
    } else {
      addFavorite(movie);
    }
  }
}
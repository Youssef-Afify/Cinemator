import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/core/utils/error_message.dart';
import 'package:task/features/movies/data/movie_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<int, MovieModel> _favorites = {};

  // Tracked explicitly (as a caller-supplied flag) rather than via an
  // `is AdminMovieModel` runtime check, so this provider doesn't need to
  // depend on the admin feature's model at all — see addFavorite/
  // toggleFavorite below.
  final Set<int> _adminMovieIds = {};

  List<MovieModel> get favorites => _favorites.values.toList();

  bool isFavorite(int movieId) => _favorites.containsKey(movieId);

  // Lets FavoritesView know whether tapping a favorite should open
  // MovieDetailsView (re-fetches from TMDB by id) or AdminMovieDetailsView
  // (needs the full admin movie object — admin ids mean nothing to TMDB).
  bool isAdminFavorite(int movieId) => _adminMovieIds.contains(movieId);

  bool isLoading = false;
  String? errorMessage;

  String? _currentUid;

  CollectionReference<Map<String, dynamic>>? _favoritesRef() {
    final uid = _currentUid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  Future<void> loadFavorites(String uid) async {
    _currentUid = uid;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .get();
      _favorites.clear();
      _adminMovieIds.clear();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final movie = MovieModel.fromJson(data);
        _favorites[movie.id] = movie;
        if (data['is_admin_movie'] == true) {
          _adminMovieIds.add(movie.id);
        }
      }
      errorMessage = null;
    } catch (e) {
      // Deliberately not clearing _favorites here: if this is a re-load
      // (not the very first one) and it fails, keeping whatever was
      // already loaded is better than replacing real data with an empty
      // list just because of a transient network error.
      errorMessage = friendlyErrorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    _adminMovieIds.clear();
    _currentUid = null;
    errorMessage = null;
    notifyListeners();
  }

  // Returns whether the favorite was actually persisted. The optimistic
  // local update happens immediately either way (for a responsive UI),
  // but if the Firestore write fails it's rolled back — without this,
  // the UI would keep showing "favorited" for something that was never
  // actually saved, and it would silently vanish on the next load.
  Future<bool> addFavorite(
    MovieModel movie, {
    bool isAdminMovie = false,
  }) async {
    if (_favorites.containsKey(movie.id)) return true;

    _favorites[movie.id] = movie;
    if (isAdminMovie) _adminMovieIds.add(movie.id);
    errorMessage = null;
    notifyListeners();

    try {
      await _favoritesRef()?.doc(movie.id.toString()).set({
        ...movie.toJson(),
        'is_admin_movie': isAdminMovie,
        'added_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      _favorites.remove(movie.id);
      _adminMovieIds.remove(movie.id);
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(int movieId) async {
    if (!_favorites.containsKey(movieId)) return true;

    final removedMovie = _favorites[movieId]!;
    final wasAdminMovie = _adminMovieIds.contains(movieId);

    _favorites.remove(movieId);
    _adminMovieIds.remove(movieId);
    errorMessage = null;
    notifyListeners();

    try {
      await _favoritesRef()?.doc(movieId.toString()).delete();
      return true;
    } catch (e) {
      // Roll back — put it back so local state agrees with Firestore
      // again, rather than showing it as removed when it never actually
      // was.
      _favorites[movieId] = removedMovie;
      if (wasAdminMovie) _adminMovieIds.add(movieId);
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleFavorite(MovieModel movie, {bool isAdminMovie = false}) {
    if (isFavorite(movie.id)) {
      return removeFavorite(movie.id);
    } else {
      return addFavorite(movie, isAdminMovie: isAdminMovie);
    }
  }
}
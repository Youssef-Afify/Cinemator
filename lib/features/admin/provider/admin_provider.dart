import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task/core/utils/error_message.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';
import 'package:task/features/admin/data/admin_movie_repository.dart';

class AdminProvider extends ChangeNotifier {
  final AdminMovieRepository repository;

  List<AdminMovieModel> adminMovies = [];
  bool isLoading = false;
  String? errorMessage;

  StreamSubscription<List<AdminMovieModel>>? _subscription;

  AdminProvider({required this.repository}) {
    _subscribeToMovies();
  }

  void _subscribeToMovies() {
    _subscription?.cancel();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _subscription = repository.watchMovies().listen(
      (movies) {
        adminMovies = movies;
        isLoading = false;
        errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        errorMessage = friendlyErrorMessage(e);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  // Re-subscribes to the movies stream. Without this there was no way to
  // recover from a stream error (e.g. a transient permission/connectivity
  // issue) short of restarting the app — the original subscription stays
  // dead once its onError fires, since a Dart Stream doesn't resume itself.
  void retry() => _subscribeToMovies();

  Future<void> addMovie(AdminMovieModel movie) async {
    try {
      await repository.addMovie(movie);
    } catch (e) {
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateMovie(AdminMovieModel movie) async {
    try {
      await repository.updateMovie(movie);
    } catch (e) {
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteMovie(String docId) async {
    try {
      await repository.deleteMovie(docId);
    } catch (e) {
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
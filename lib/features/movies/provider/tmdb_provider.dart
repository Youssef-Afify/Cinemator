import 'package:flutter/material.dart';
import 'package:task/core/constants/enums.dart';
import 'package:task/core/utils/error_message.dart';
import '../../movie_details/data/movie_details_model.dart';
import '../data/movie_model.dart';
import '../data/movie_repository.dart';

class TmdbProvider extends ChangeNotifier {
  final MovieRepository repository;

  Map<CategoryGet, List<MovieModel>> movies = {
    CategoryGet.popular: [],
    CategoryGet.nowPlaying: [],
    CategoryGet.upcoming: [],
    CategoryGet.topRated: [],
  };

  // Per-category loading/error/pagination state. Kept separate per key
  // (rather than as single shared fields) because the four categories are
  // fetched concurrently — sharing one `isLoading`/`errorMessage`/etc. would
  // mean whichever request finishes last silently overwrites the others'
  // state, and a single failed category would wrongly blank out every
  // other category that actually succeeded.
  Map<CategoryGet, bool> categoryLoading = {
    for (final c in CategoryGet.values) c: false,
  };
  Map<CategoryGet, String?> categoryError = {
    for (final c in CategoryGet.values) c: null,
  };
  Map<CategoryGet, int> categoryPage = {
    for (final c in CategoryGet.values) c: 1,
  };
  Map<CategoryGet, int> categoryTotalPages = {
    for (final c in CategoryGet.values) c: 1,
  };
  Map<CategoryGet, bool> categoryHasMore = {
    for (final c in CategoryGet.values) c: true,
  };

  // Legacy shared fields — kept only because `fetchMoviesByCategory` below
  // (the older infinite-scroll variant) still uses them. Not touched by
  // `fetchMoviesPage` anymore.
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;
  bool hasMorePages = true;

  // ========== Genre browsing state ==========
  // Kept separate from the category state above so browsing movies by
  // genre never clashes with (or resets) the category lists/pagination.
  List<MovieModel> genreMovies = [];
  bool isGenreLoading = false;
  String? genreErrorMessage;
  int genreCurrentPage = 1;
  bool genreHasMorePages = true;
  int? _lastGenreId;

  // ========== Search state ==========
  // Kept separate from both the category state and the genre state so a
  // search never overwrites data that "Now Playing" / genre browsing rely on.
  List<MovieModel> searchResults = [];
  bool isSearching = false;
  String? searchErrorMessage;
  String currentQuery = '';

  TmdbProvider({required this.repository});

  // Existing method — kept as-is for infinite-scroll / search use cases.
  Future<void> fetchMoviesByCategory({
    bool refresh = false,
    required CategoryGet category,
  }) async {
    if (refresh) {
      currentPage = 1;
      movies[category]!.clear();
      hasMorePages = true;
    }

    if (!hasMorePages || isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.getByCategory(
        page: currentPage,
        category: category,
      );
      movies[category]!.addAll(response.results);

      hasMorePages = currentPage < response.totalPages;
      currentPage++;
      errorMessage = null;
    } catch (e) {
      errorMessage = friendlyErrorMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetches a single page and replaces the list for that category.
  // Safe to call concurrently for different categories — each category's
  // loading/error/pagination state is tracked independently.
  Future<void> fetchMoviesPage({
    required int page,
    required CategoryGet category,
  }) async {
    categoryLoading[category] = true;
    categoryError[category] = null;
    notifyListeners();

    try {
      final response = await repository.getByCategory(
        page: page,
        category: category,
      );
      movies[category] = response.results;
      categoryPage[category] = page;
      categoryTotalPages[category] = response.totalPages;
      categoryHasMore[category] = page < response.totalPages;
      categoryError[category] = null;
    } catch (e) {
      categoryError[category] = friendlyErrorMessage(e);
    } finally {
      categoryLoading[category] = false;
      notifyListeners();
    }
  }

  // Refetches page 1 for every category, unconditionally replacing
  // whatever's currently loaded — this is what pull-to-refresh calls.
  //
  // fetchMoviesPage itself already always hits the network and replaces
  // the list on every call, so no separate "refresh" flag is needed on it;
  // what was actually missing was a caller that doesn't skip already-loaded
  // categories the way MoviesView's initial load does (see MoviesView,
  // which only calls fetchMoviesPage for a category if it's empty, so the
  // same data sticks around for the rest of the app session unless the
  // user explicitly asks for new data).
  Future<void> refreshAllCategories() {
    return Future.wait([
      for (final category in CategoryGet.values)
        fetchMoviesPage(category: category, page: 1),
    ]);
  }
  // Kept separate from fetchMoviesPage (which replaces page 1 for the
  // horizontal row) so the two don't stomp on each other's pagination —
  // this one continues from whatever page fetchMoviesPage already loaded,
  // so opening "View All" doesn't refetch page 1 from scratch.
  Future<void> loadMoreForCategory(CategoryGet category) async {
    final alreadyLoading = categoryLoading[category] ?? false;
    final hasMore = categoryHasMore[category] ?? true;
    if (alreadyLoading || !hasMore) return;

    categoryLoading[category] = true;
    categoryError[category] = null;
    notifyListeners();

    final nextPage = (categoryPage[category] ?? 0) + 1;

    try {
      final response = await repository.getByCategory(
        page: nextPage,
        category: category,
      );
      movies[category] = [...(movies[category] ?? []), ...response.results];
      categoryPage[category] = nextPage;
      categoryTotalPages[category] = response.totalPages;
      categoryHasMore[category] = nextPage < response.totalPages;
      categoryError[category] = null;
    } catch (e) {
      categoryError[category] = friendlyErrorMessage(e);
    } finally {
      categoryLoading[category] = false;
      notifyListeners();
    }
  }

  // Searches movies globally (TMDB's search endpoint isn't category-scoped).
  // An empty query clears the results instead of issuing a request.
  // Guards against out-of-order responses: if a newer query has been typed
  // by the time an older request resolves, that stale response is dropped.
  Future<void> searchMovies(String query) async {
    currentQuery = query;

    if (query.trim().isEmpty) {
      searchResults = [];
      searchErrorMessage = null;
      isSearching = false;
      notifyListeners();
      return;
    }

    isSearching = true;
    searchErrorMessage = null;
    notifyListeners();

    try {
      final response = await repository.searchMovies(query);
      if (query != currentQuery) return; // a newer search superseded this one

      searchResults = response.results;
      searchErrorMessage = null;
    } catch (e) {
      if (query != currentQuery) return;
      searchErrorMessage = friendlyErrorMessage(e);
      searchResults = [];
    } finally {
      if (query == currentQuery) {
        isSearching = false;
        notifyListeners();
      }
    }
  }

  void clearSearch() {
    currentQuery = '';
    searchResults = [];
    searchErrorMessage = null;
    isSearching = false;
    notifyListeners();
  }

  Future<MovieDetailsModel?> getMovieDetails(int id) async {
    try {
      return await repository.getMovieDetails(id);
    } catch (e) {
      errorMessage = friendlyErrorMessage(e);
      notifyListeners();
      return null;
    }
  }

  // Fetches movies for a given genre, appending pages for infinite scroll.
  // Automatically resets pagination when either `refresh` is passed or the
  // requested genre differs from the last one fetched (e.g. navigating from
  // one genre page to another).
  Future<void> fetchMoviesByGenre(int genreId, {bool refresh = false}) async {
    if (refresh || _lastGenreId != genreId) {
      genreCurrentPage = 1;
      genreMovies = [];
      genreHasMorePages = true;
      _lastGenreId = genreId;
    }

    if (!genreHasMorePages || isGenreLoading) return;

    isGenreLoading = true;
    genreErrorMessage = null;
    notifyListeners();

    try {
      final response = await repository.getMoviesByGenre(
        genreId: genreId,
        page: genreCurrentPage,
      );

      genreMovies.addAll(response.results);
      genreHasMorePages = genreCurrentPage < response.totalPages;
      genreCurrentPage++;
      genreErrorMessage = null;
    } catch (e) {
      genreErrorMessage = friendlyErrorMessage(e);
    } finally {
      isGenreLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void clearGenreError() {
    genreErrorMessage = null;
    notifyListeners();
  }
}
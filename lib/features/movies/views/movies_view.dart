import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/core/constants/enums.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/category_section.dart';
import 'package:task/features/movies/widgets/search_results.dart';
import 'package:task/features/movies/views/category_movies_page.dart';
import 'package:task/shared/app_drawer.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/shared/search_field.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView>
    with AutomaticKeepAliveClientMixin<MoviesView> {
  TextEditingController movieController = TextEditingController();
  String searchText = '';
  Timer? _searchDebounce;

  // Tells the enclosing PageView to never dispose this tab's state just
  // because it scrolled out of the page cache — without this, switching
  // to another tab and back can silently rebuild MoviesView and re-run
  // initState, re-fetching every category from the network again.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Each category tracks its own loading/error/pagination state on the
    // provider now, so firing all four concurrently is safe — one category
    // failing (e.g. a transient rate limit) no longer blanks the others.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<TmdbProvider>();
      for (final category in CategoryGet.values) {
        // TmdbProvider outlives this screen, so if a category already has
        // movies (e.g. this is a keep-alive rebuild, or a hot reload),
        // there's no need to hit the network again for it.
        final alreadyLoaded = (provider.movies[category] ?? []).isNotEmpty;
        if (!alreadyLoaded) {
          provider.fetchMoviesPage(category: category, page: 1);
        }
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => searchText = value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<TmdbProvider>().searchMovies(value);
      }
    });
  }

  @override
  void dispose() {
    movieController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _openMovie(int movieId) {
    Navigator.of(context).push(
      route(MovieDetailsView(movieId: movieId)),
    );
  }

  void _viewAll(String title, CategoryGet category) {
    Navigator.of(context).push(
      route(CategoryMoviesPage(title: title, category: category)),
    );
  }

  // Pull-to-refresh: if a search is active, re-run it (so pulling down
  // doesn't silently refresh category data the user can't currently see);
  // otherwise refetch every category from scratch.
  Future<void> _onRefresh(TmdbProvider provider) {
    if (provider.currentQuery.trim().isNotEmpty) {
      return provider.searchMovies(provider.currentQuery);
    }
    return provider.refreshAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: CustomAppBar(AppInfo.name, hasDrawer: true),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<TmdbProvider>(
            builder: (context, provider, child) {
              final isSearchActive = provider.currentQuery.trim().isNotEmpty;
              return RefreshIndicator(
                onRefresh: () => _onRefresh(provider),
                color: AppColors.primary,
                backgroundColor: AppColors.bg,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SearchField(
                        controller: movieController,
                        onSearch: _onSearchChanged,
                      ),
                      const Gap(20),
                      if (isSearchActive)
                        SearchResults(provider: provider)
                      else ...[
                        CategorySection(
                          title: 'Popular',
                          category: CategoryGet.popular,
                          onMovieTap: (movie) => _openMovie(movie.id),
                          onViewAll: () =>
                              _viewAll('Popular', CategoryGet.popular),
                        ),
                        const Gap(10),
                        const Divider(),
                        const Gap(10),
                        CategorySection(
                          title: 'Now Playing',
                          category: CategoryGet.nowPlaying,
                          onMovieTap: (movie) => _openMovie(movie.id),
                          onViewAll: () =>
                              _viewAll('Now Playing', CategoryGet.nowPlaying),
                        ),
                        const Gap(10),
                        const Divider(),
                        const Gap(10),
                        CategorySection(
                          title: 'Upcoming',
                          category: CategoryGet.upcoming,
                          onMovieTap: (movie) => _openMovie(movie.id),
                          onViewAll: () =>
                              _viewAll('Upcoming', CategoryGet.upcoming),
                        ),
                        const Gap(10),
                        const Divider(),
                        const Gap(10),
                        CategorySection(
                          title: 'Top Rated',
                          category: CategoryGet.topRated,
                          onMovieTap: (movie) => _openMovie(movie.id),
                          onViewAll: () =>
                              _viewAll('Top Rated', CategoryGet.topRated),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
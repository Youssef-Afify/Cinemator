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
import 'package:task/shared/app_drawer.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/shared/search_field.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  TextEditingController movieController = TextEditingController();
  String searchText = '';
  Timer? _searchDebounce;

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
        provider.fetchMoviesPage(category: category, page: 1);
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

  @override
  Widget build(BuildContext context) {
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
              return SingleChildScrollView(
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
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(10),
                      CategorySection(
                        title: 'Now Playing',
                        category: CategoryGet.nowPlaying,
                        onMovieTap: (movie) => _openMovie(movie.id),
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(10),
                      CategorySection(
                        title: 'Upcoming',
                        category: CategoryGet.upcoming,
                        onMovieTap: (movie) => _openMovie(movie.id),
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(10),
                      CategorySection(
                        title: 'Top Rated',
                        category: CategoryGet.topRated,
                        onMovieTap: (movie) => _openMovie(movie.id),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

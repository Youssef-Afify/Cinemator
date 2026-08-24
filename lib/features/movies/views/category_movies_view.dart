import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/enums.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class CategoryMoviesView extends StatefulWidget {
  final String title;
  final CategoryGet category;

  const CategoryMoviesView({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  State<CategoryMoviesView> createState() => _CategoryMoviesViewState();
}

class _CategoryMoviesViewState extends State<CategoryMoviesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // The horizontal row on the Movies tab has almost always already
    // fetched page 1 by the time this screen opens — reuse that instead
    // of refetching. Only kick off a fetch here if there's genuinely
    // nothing loaded yet (and nothing already in flight).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<TmdbProvider>();
      final hasMovies = (provider.movies[widget.category] ?? []).isNotEmpty;
      final isLoading = provider.categoryLoading[widget.category] ?? false;
      if (!hasMovies && !isLoading) {
        provider.loadMoreForCategory(widget.category);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TmdbProvider>().loadMoreForCategory(widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.bg,
        bottom: CustomAppBar(widget.title, goBack: true),
      ),
      body: Consumer<TmdbProvider>(
        builder: (context, provider, child) {
          final movies = provider.movies[widget.category] ?? [];
          final isLoading = provider.categoryLoading[widget.category] ?? false;
          final error = provider.categoryError[widget.category];
          final hasMore = provider.categoryHasMore[widget.category] ?? false;

          if (isLoading && movies.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 30,
              ),
            );
          }

          if (error != null && movies.isEmpty) {
            return Center(
              child: ErrorRetry(
                message: error,
                onRetry: () => context.read<TmdbProvider>().loadMoreForCategory(
                  widget.category,
                ),
              ),
            );
          }

          if (movies.isEmpty) {
            return const Center(
              child: CustomText('No movies found', color: Colors.white),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: movies.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                );
              }
              final movie = movies[index];
              return CustomMovieCard(
                movie: movie,
                onTap: () =>
                    Navigator.of(context).push(route(MovieDetailsView(movieId: movie.id))),
              );
            },
          );
        },
      ),
    );
  }
}
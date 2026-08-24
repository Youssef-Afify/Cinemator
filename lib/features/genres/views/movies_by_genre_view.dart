import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class MoviesByGenreView extends StatefulWidget {
  final int genreId;
  final String genreName;

  const MoviesByGenreView({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<MoviesByGenreView> createState() => _MoviesByGenreViewState();
}

class _MoviesByGenreViewState extends State<MoviesByGenreView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TmdbProvider>().fetchMoviesByGenre(widget.genreId);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TmdbProvider>().fetchMoviesByGenre(widget.genreId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.bg,
        bottom: CustomAppBar(widget.genreName, goBack: true),
      ),
      body: Consumer<TmdbProvider>(
        builder: (context, provider, child) {
          if (provider.isGenreLoading && provider.genreMovies.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 30,
              ),
            );
          }

          if (provider.genreErrorMessage != null) {
            return Center(
              child: ErrorRetry(
                message: provider.genreErrorMessage!,
                onRetry: () => provider.fetchMoviesByGenre(
                  widget.genreId,
                  refresh: true,
                ),
              ),
            );
          }

          if (provider.genreMovies.isEmpty) {
            return const Center(
              child: CustomText(
                'No movies found in this genre',
                color: Colors.white,
              ),
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
            itemCount:
                provider.genreMovies.length +
                (provider.genreHasMorePages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.genreMovies.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                );
              }
              final movie = provider.genreMovies[index];
              return CustomMovieCard(
                movie: movie,
                onTap: () => Navigator.of(
                  context,
                ).push(route(MovieDetailsView(movieId: movie.id))),
              );
            },
          );
        },
      ),
    );
  }
}
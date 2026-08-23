import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/enums.dart';
import 'package:task/features/movies/data/movie_model.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final CategoryGet category;
  final VoidCallback? onViewAll;
  final ValueChanged<MovieModel>? onMovieTap;

  const CategorySection({
    super.key,
    required this.title,
    required this.category,
    this.onViewAll,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade300,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.secondary),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: Consumer<TmdbProvider>(
            builder: (context, provider, child) {
              final isLoading = provider.categoryLoading[category] ?? false;
              final error = provider.categoryError[category];
              final categoryMovies = provider.movies[category] ?? [];

              if (isLoading && categoryMovies.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primary,
                    size: 24,
                  ),
                );
              }

              if (error != null && categoryMovies.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<TmdbProvider>().fetchMoviesPage(
                          category: category,
                          page: 1,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (categoryMovies.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'No movies found',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (final movie in categoryMovies) ...[
                      CustomMovieCard(
                        movie: movie,
                        onTap: onMovieTap == null
                            ? null
                            : () => onMovieTap!(movie),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
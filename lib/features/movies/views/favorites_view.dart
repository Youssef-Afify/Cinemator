import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/material_page_route.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  void _openMovie(BuildContext context, int movieId) {
    Navigator.of(context).push(route(MovieDetailsView(movieId: movieId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const CustomAppBar('Favorites'),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white38,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const CustomText(
                      'No favorites yet',
                      color: Colors.white,
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Movies you add to favorites will show up here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.neutral, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return CustomMovieCard(
                  movie: movie,
                  onTap: () => _openMovie(context, movie.id),
                  isFavorite: true,
                  onFavoriteToggle: () =>
                      favoritesProvider.removeFavorite(movie.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

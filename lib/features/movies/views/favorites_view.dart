import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/admin/provider/admin_provider.dart';
import 'package:task/features/admin/views/admin_movie_details_view.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  void _openMovie(BuildContext context, int movieId, bool isAdminMovie) {
    if (isAdminMovie) {
      // AdminMovieDetailsView needs the full movie object (it doesn't
      // re-fetch by id the way MovieDetailsView does — an admin movie's id
      // means nothing to TMDB). Look it up from AdminProvider's live list
      // rather than reconstructing one from the favorites doc, so this
      // also shows the current version if the admin has since edited it.
      final adminMovies = context.read<AdminProvider>().adminMovies;
      final matches = adminMovies.where((m) => m.id == movieId);
      final movie = matches.isEmpty ? null : matches.first;
      if (movie == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This movie is no longer available.'),
          ),
        );
        return;
      }
      Navigator.of(context).push(route(AdminMovieDetailsView(movie: movie)));
      return;
    }
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

          if (favoritesProvider.isLoading && favorites.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 30,
              ),
            );
          }

          if (favoritesProvider.errorMessage != null && favorites.isEmpty) {
            // Distinguishing this from "genuinely no favorites" matters —
            // without it, a failed load (e.g. offline) looked identical to
            // an empty list, which is actively misleading for a user who
            // actually has favorites saved.
            return Center(
              child: ErrorRetry(
                message: favoritesProvider.errorMessage!,
                onRetry: () {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) favoritesProvider.loadFavorites(uid);
                },
              ),
            );
          }

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
                  onTap: () => _openMovie(
                    context,
                    movie.id,
                    favoritesProvider.isAdminFavorite(movie.id),
                  ),
                  isFavorite: true,
                  onFavoriteToggle: () async {
                    final success = await favoritesProvider.removeFavorite(
                      movie.id,
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            favoritesProvider.errorMessage ??
                                'Something went wrong. Please try again.',
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
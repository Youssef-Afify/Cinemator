import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';

class SearchResults extends StatelessWidget {
  final TmdbProvider provider;

  const SearchResults({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isSearching && provider.searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: AppColors.primary,
            size: 30,
          ),
        ),
      );
    }

    if (provider.searchErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Text(
              'Error: ${provider.searchErrorMessage}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TmdbProvider>().searchMovies(
                provider.currentQuery,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No movies found',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final movie = provider.searchResults[index];
        return CustomMovieCard(
          movie: movie,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MovieDetailsView(movieId: movie.id),
            ),
          ),
        );
      },
    );
  }
}
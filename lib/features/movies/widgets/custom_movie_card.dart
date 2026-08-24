import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/data/movie_model.dart';
import 'package:task/shared/custom_text.dart';

class CustomMovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  // Optional favorite-toggle affordance: when a callback is provided, a
  // heart button renders in the top-left corner (mirroring the rating
  // pill's top-right position) so a card can be favorited/unfavorited
  // without needing a whole separate screen.
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const CustomMovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 150,
    this.height = 280,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      color: const Color(0xFF1A1A1A),
                      child: movie.posterPath != null
                          ? Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.movie,
                                color: Colors.white24,
                                size: 40,
                              ),
                            )
                          : const Icon(
                              Icons.movie,
                              color: Colors.white24,
                              size: 40,
                            ),
                    ),
                  ),
                  // Subtle bottom gradient so a badge/title never fights the art.
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(18),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Rating pill.
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFFFC940),
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            movie.formattedRating,
                            color: Colors.white,
                            size: 12,
                            weight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        // Own hit target so tapping the heart doesn't also
                        // trigger the card's onTap (which opens details).
                        onTap: onFavoriteToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFavorite
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(10),
            CustomText(
              movie.title,
              color: Colors.white,
              size: 15,
              weight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Gap(2),
            // Swap for a genre string here if MovieModel exposes one.
            CustomText(
              movie.releaseYear,
              color: AppColors.neutral,
              size: 13,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

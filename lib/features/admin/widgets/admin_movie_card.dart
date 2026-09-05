import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';
import 'package:task/shared/custom_text.dart';

/// A movie card for admin-created movies. Visually identical to
/// [CustomMovieCard] but typed to [AdminMovieModel].
class AdminMovieCard extends StatelessWidget {
  final AdminMovieModel movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const AdminMovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 150,
    this.height = 280,
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
                      child: movie.posterPath != null &&
                              movie.posterPath!.isNotEmpty
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
                  // Bottom gradient
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
                  // Rating badge
                  if (movie.voteAverage != null)
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
                  // "By Cinemator" badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const CustomText(
                        'Cinemator',
                        color: Colors.white,
                        size: 9,
                        weight: FontWeight.w800,
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
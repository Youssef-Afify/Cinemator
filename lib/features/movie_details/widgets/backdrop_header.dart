import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movie_details/data/movie_details_model.dart';
import 'package:task/shared/custom_text.dart';

class BackdropHeader extends StatelessWidget {
  final MovieDetailsModel movie;

  const BackdropHeader({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.backdropPath != null
                ? Image.network(
                    movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: const Color(0xFF1A1A1A)),
                  )
                : Container(color: const Color(0xFF1A1A1A)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.1), AppColors.bg],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFFFC940),
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        movie.formattedRating,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

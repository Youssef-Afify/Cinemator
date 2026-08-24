import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movie_details/data/movie_details_model.dart';
import 'package:task/shared/custom_text.dart';

class MetaRow extends StatelessWidget {
  final MovieDetailsModel movie;

  const MetaRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC940)),
          const SizedBox(width: 4),
          CustomText(
            movie.formattedRating,
            color: AppColors.neutral,
            weight: FontWeight.w600,
          ),
        ],
      ),
      CustomText('•', color: AppColors.neutral),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            movie.releaseYear,
            color: AppColors.neutral,
            weight: FontWeight.w600,
          ),
          if (movie.adult) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const CustomText(
                '+18',
                color: Colors.white,
                size: 10,
                weight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    ];

    if (movie.formattedRuntime.isNotEmpty) {
      children.add(CustomText('•', color: AppColors.neutral));
      children.add(
        CustomText(
          movie.formattedRuntime,
          color: AppColors.neutral,
          weight: FontWeight.w600,
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: children,
    );
  }
}

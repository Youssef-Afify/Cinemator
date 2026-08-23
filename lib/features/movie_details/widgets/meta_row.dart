import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movie_details/data/movie_details_model.dart';

class MetaRow extends StatelessWidget {
  final MovieDetailsModel movie;

  const MetaRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final dotStyle = TextStyle(color: AppColors.neutral);
    final textStyle =
        TextStyle(color: AppColors.neutral, fontWeight: FontWeight.w600);

    final children = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC940)),
          const SizedBox(width: 4),
          Text(movie.formattedRating, style: textStyle),
        ],
      ),
      Text('•', style: dotStyle),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(movie.releaseYear, style: textStyle),
          if (movie.adult) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '+18',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    ];

    if (movie.formattedRuntime.isNotEmpty) {
      children.add(Text('•', style: dotStyle));
      children.add(Text(movie.formattedRuntime, style: textStyle));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: children,
    );
  }
}
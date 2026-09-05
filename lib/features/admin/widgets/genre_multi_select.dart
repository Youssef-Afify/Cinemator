import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/genres/provider/genre_provider.dart';
import 'package:task/shared/custom_text.dart';

// Reuses the genre list the rest of the app already loads via
// GenreProvider — this widget only displays/toggles, it doesn't trigger
// loadGenres() itself (that's the form's job, in initState; triggering a
// provider fetch from inside build() risks a "setState during build"
// error, since loadGenres() calls notifyListeners() before its first
// await).
class GenreMultiSelect extends StatelessWidget {
  final List<GenreModel> selected;
  final ValueChanged<List<GenreModel>> onChanged;

  const GenreMultiSelect({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.genres.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CustomText('Loading genres…', color: Colors.white54),
          );
        }

        if (provider.genres.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CustomText('No genres available', color: Colors.white54),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.genres.map((genre) {
            final isSelected = selected.any((g) => g.id == genre.id);
            return GestureDetector(
              onTap: () {
                final updated = List<GenreModel>.of(selected);
                if (isSelected) {
                  updated.removeWhere((g) => g.id == genre.id);
                } else {
                  updated.add(genre);
                }
                onChanged(updated);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF353534),
                    width: 1.5,
                  ),
                ),
                child: CustomText(
                  genre.name,
                  color: Colors.white,
                  size: 13,
                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
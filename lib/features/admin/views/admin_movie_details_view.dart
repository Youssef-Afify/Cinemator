import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';
import 'package:task/features/admin/provider/admin_provider.dart';
import 'package:task/features/admin/views/admin_movie_form_view.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/movie_details/widgets/genre_chip.dart';
import 'package:task/features/movie_details/widgets/cast_tile.dart';
import 'package:task/features/movie_details/widgets/meta_row.dart';
import 'package:task/features/movie_details/widgets/trailer_card.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/material_page_route.dart';

class AdminMovieDetailsView extends StatelessWidget {
  final AdminMovieModel movie;

  const AdminMovieDetailsView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<UserProvider>().isAdmin;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── Backdrop Header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop image
                  movie.backdropPath != null && movie.backdropPath!.isNotEmpty
                      ? Image.network(
                          movie.backdropUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(color: const Color(0xFF1A1A1A)),
                        )
                      : Container(color: const Color(0xFF1A1A1A)),
                  // Gradient fade
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          AppColors.bg,
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  // Back button
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
                  // Rating badge
                  if (movie.voteAverage != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Color(0xFFFFC940)),
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
          ),

          // ── Body ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    movie.title,
                    color: Colors.white,
                    size: 26,
                    weight: FontWeight.w800,
                  ),
                  const Gap(10),
                  MetaRow(movie: movie),

                  // Genre chips
                  if ((movie.genres ?? []).isNotEmpty) ...[
                    const Gap(14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genres!
                          .map((g) => GenreChip(
                                name: g.name,
                                color: AppColors.secondary,
                              ))
                          .toList(),
                    ),
                  ],

                  const Gap(24),

                  // ── Favorite button ──────────────────────────────────
                  Consumer<FavoritesProvider>(
                    builder: (context, fav, _) {
                      final isFavorite = fav.isFavorite(movie.id);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final success = await fav.toggleFavorite(
                              movie,
                              isAdminMovie: true,
                            );
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    fav.errorMessage ??
                                        'Something went wrong. Please try again.',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          label: CustomText(
                            isFavorite
                                ? 'Added to Favorites'
                                : 'Add to Favorites',
                            color: Colors.white,
                            weight: FontWeight.w700,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ── Admin action buttons (Edit / Delete) ─────────────
                  if (isAdmin) ...[
                    const Gap(12),
                    Row(
                      children: [
                        // Edit Movie
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                route(AdminMovieFormView(existing: movie)),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Movie'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: AppColors.secondary, width: 1.5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const Gap(12),
                        // Delete Movie
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _confirmDelete(context, movie.docId),
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Delete Movie'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                  color: AppColors.primary, width: 1.5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Tagline ──────────────────────────────────────────
                  if ((movie.tagline ?? '').isNotEmpty) ...[
                    const Gap(24),
                    Text(
                      '"${movie.tagline!}"',
                      style: TextStyle(
                        color: AppColors.neutral,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],

                  // ── Overview ─────────────────────────────────────────
                  if ((movie.overview ?? '').isNotEmpty) ...[
                    const Gap(32),
                    const CustomText(
                      'Synopsis',
                      color: Colors.white,
                      size: 18,
                      weight: FontWeight.w800,
                    ),
                    const Gap(10),
                    Text(
                      movie.overview!,
                      style: TextStyle(
                        color: AppColors.neutral,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],

                  // ── Top Cast ─────────────────────────────────────────
                  if ((movie.cast ?? []).isNotEmpty) ...[
                    const Gap(32),
                    const CustomText(
                      'Top Cast',
                      color: Colors.white,
                      size: 18,
                      weight: FontWeight.w800,
                    ),
                    const Gap(14),
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: movie.cast!.length > 12
                            ? 12
                            : movie.cast!.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 16),
                        itemBuilder: (context, index) =>
                            CastTile(cast: movie.cast![index]),
                      ),
                    ),
                  ],

                  // ── Trailer ──────────────────────────────────────────
                  if (movie.trailer != null) ...[
                    const Gap(32),
                    const CustomText(
                      'Trailers & More',
                      color: Colors.white,
                      size: 18,
                      weight: FontWeight.w800,
                    ),
                    const Gap(14),
                    TrailerCard(video: movie.trailer!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Movie?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'This action cannot be undone. The movie will be permanently removed.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // close dialog
              try {
                await context.read<AdminProvider>().deleteMovie(docId);
                if (context.mounted) Navigator.of(context).pop(); // close detail
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Failed to delete movie. Please try again.')),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
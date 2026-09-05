import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/features/movie_details/widgets/backdrop_header.dart';
import 'package:task/features/movie_details/widgets/cast_tile.dart';
import 'package:task/features/movie_details/widgets/error_state.dart';
import 'package:task/features/movie_details/widgets/genre_chip.dart';
import 'package:task/features/movie_details/widgets/meta_row.dart';
import 'package:task/features/movie_details/widgets/trailer_card.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movie_details/data/movie_details_model.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/shared/custom_text.dart';

class MovieDetailsView extends StatefulWidget {
  final int movieId;

  const MovieDetailsView({super.key, required this.movieId});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  late final Future<MovieDetailsModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<TmdbProvider>().getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FutureBuilder<MovieDetailsModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 24,
              ),
            );
          }

          final movie = snapshot.data;
          if (movie == null) {
            return ErrorState(onBack: Navigator.of(context).pop);
          }

          return CustomScrollView(
            slivers: [
              BackdropHeader(movie: movie),
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
                      if ((movie.genres ?? []).isNotEmpty) ...[
                        const Gap(14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres!
                              .map(
                                (g) => GenreChip(
                                  name: g.name,
                                  color: AppColors.secondary,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const Gap(24),
                      Consumer<FavoritesProvider>(
                        builder: (context, favoritesProvider, child) {
                          final isFavorite = favoritesProvider.isFavorite(
                            movie.id,
                          );
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final success = await favoritesProvider
                                    .toggleFavorite(movie);
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) =>
                                CastTile(cast: movie.cast![index]),
                          ),
                        ),
                      ],
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
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/genres/provider/genre_provider.dart';
import 'package:task/features/genres/views/movies_by_genre_page.dart';
import 'package:task/features/genres/widgets/genre_tile.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/material_page_route.dart';

class GenresView extends StatefulWidget {
  const GenresView({super.key});

  @override
  State<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenreProvider>().loadGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar('Genres'),
      body: Consumer<GenreProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoading && provider.genres.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 30,
              ),
            );
          }

          // Error state
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    'Error: ${provider.errorMessage}',
                    color: Colors.white,
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () => provider.loadGenres(refresh: true),
                    child: const CustomText('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (provider.genres.isEmpty) {
            return const Center(
              child: CustomText('No genres found', color: Colors.white),
            );
          }

          // Success state
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.7,
              ),
              itemCount: provider.genres.length,
              itemBuilder: (context, index) {
                final genre = provider.genres[index];
                return GenreTile(
                  genre: genre,
                  onTap: () {
                    Navigator.push(
                      context,
                      route(
                        MoviesByGenrePage(
                          genreId: genre.id,
                          genreName: genre.name,
                        ),
                      ),
                    );
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

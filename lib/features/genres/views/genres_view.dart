import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/genres/provider/genre_provider.dart';
import 'package:task/features/genres/views/movies_by_genre_page.dart';
import 'package:task/features/genres/widgets/genre_tile.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class GenresView extends StatefulWidget {
  const GenresView({super.key});

  @override
  State<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView>
    with AutomaticKeepAliveClientMixin<GenresView> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<GenreProvider>();
      if (provider.genres.isEmpty) {
        provider.loadGenres();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar('Genres'),
      body: Consumer<GenreProvider>(
        builder: (context, provider, child) {

          if (provider.isLoading && provider.genres.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 30,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: ErrorRetry(
                message: provider.errorMessage!,
                onRetry: () => provider.loadGenres(refresh: true),
              ),
            );
          }

          if (provider.genres.isEmpty) {
            return const Center(
              child: CustomText('No genres found', color: Colors.white),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadGenres(refresh: true),
            color: AppColors.primary,
            backgroundColor: AppColors.bg,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';
import 'package:task/features/admin/provider/admin_provider.dart';
import 'package:task/features/admin/views/admin_movie_details_view.dart';
import 'package:task/features/admin/views/admin_movie_form_view.dart';
import 'package:task/features/admin/widgets/admin_movie_card.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_app_bar.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class AdminMoviesView extends StatelessWidget {
  const AdminMoviesView({super.key});

  void _openMovie(BuildContext context, AdminMovieModel movie) {
    Navigator.of(context).push(
      route(AdminMovieDetailsView(movie: movie)),
    );
  }

  void _openAddForm(BuildContext context) {
    Navigator.of(context).push(route(const AdminMovieFormView()));
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<UserProvider>().isAdmin;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const CustomAppBar('By Cinemator'),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          // Loading state
          if (provider.isLoading && provider.adminMovies.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primary,
                size: 24,
              ),
            );
          }

          // Error state
          if (provider.errorMessage != null && provider.adminMovies.isEmpty) {
            return Center(
              child: ErrorRetry(
                message: provider.errorMessage!,
                onRetry: provider.retry,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),

                // ── "Add Movie" button — visible only to admins ────────
                if (isAdmin) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openAddForm(context),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add Movie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],

                // ── Movies grid or empty state ─────────────────────────
                if (provider.adminMovies.isEmpty)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.movie_creation_outlined,
                              color: Colors.white24,
                              size: 64,
                            ),
                            const Gap(16),
                            const CustomText(
                              'No movies yet',
                              color: Colors.white,
                              size: 16,
                              weight: FontWeight.w700,
                            ),
                            const Gap(8),
                            Text(
                              isAdmin
                                  ? 'Tap "Add Movie" to create the first Cinemator movie.'
                                  : 'Movies created by the Cinemator team will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.neutral,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: provider.adminMovies.length,
                      itemBuilder: (context, index) {
                        final movie = provider.adminMovies[index];
                        return AdminMovieCard(
                          movie: movie,
                          onTap: () => _openMovie(context, movie),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';
import 'package:task/features/movies/widgets/suggestion_card.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/error_retry.dart';
import 'package:task/shared/material_page_route.dart';

class SuggestionsSlider extends StatefulWidget {
  const SuggestionsSlider({super.key});

  @override
  State<SuggestionsSlider> createState() => _SuggestionsSliderState();
}

class _SuggestionsSliderState extends State<SuggestionsSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.86);
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<TmdbProvider>();
      if (provider.suggestions.isEmpty && !provider.isLoadingSuggestions) {
        provider.loadSuggestions();
      }
    });
    _startAutoAdvance();
  }

  // Restarted every time the page changes — whether that change came from
  // this timer or from the user swiping — so a manual swipe always buys a
  // fresh 5 seconds rather than fighting with an auto-advance that's about
  // to fire a moment later.
  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final count = context.read<TmdbProvider>().suggestions.length;
      if (count == 0) return;
      final next = (_currentPage + 1) % count;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TmdbProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Suggestions',
                    color: Colors.grey.shade300,
                    size: 26,
                    weight: FontWeight.w800,
                  ),
                  _buildIcon(provider),
                ],
              ),
            ),
            const Gap(16),
            SizedBox(height: 500, child: _buildBody(provider)),
            if (provider.suggestions.length > 1) ...[
              const Gap(10),
              _buildDots(provider.suggestions.length),
            ],
          ],
        );
      },
    );
  }

  Widget _buildIcon(TmdbProvider provider) {
    if (provider.isLoadingSuggestions) {
      return LoadingAnimationWidget.threeArchedCircle(
        color: AppColors.secondary,
        size: 24,
      );
    }
    return GestureDetector(
      onTap: () => provider.loadSuggestions(forceNewPage: true),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.refresh_rounded,
          color: AppColors.secondary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBody(TmdbProvider provider) {
    if (provider.isLoadingSuggestions && provider.suggestions.isEmpty) {
      return Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppColors.primary,
          size: 28,
        ),
      );
    }

    if (provider.suggestionsErrorMessage != null &&
        provider.suggestions.isEmpty) {
      return Center(
        child: ErrorRetry(
          message: provider.suggestionsErrorMessage!,
          onRetry: () => provider.loadSuggestions(),
        ),
      );
    }

    if (provider.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: provider.suggestions.length,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
        _startAutoAdvance();
      },
      itemBuilder: (context, index) {
        final movie = provider.suggestions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SuggestionCard(
            movie: movie,
            onTap: () => Navigator.of(
              context,
            ).push(route(MovieDetailsView(movieId: movie.id))),
          ),
        );
      },
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.neutral.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

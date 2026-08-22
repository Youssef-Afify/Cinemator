import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/provider/movies_provider.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/views/movie_details.dart';
import 'package:task/widgets/custom_app_bar.dart';
import 'package:task/features/movies/widgets/custom_movie_tile.dart';
import 'package:task/widgets/search_field.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  TextEditingController movieController = TextEditingController();
  String searchText = '';
  bool favoriteFilter = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => context.read<MoviesProvider>().applyFilters(
    //     searchText,
    //     favoriteFilter,
    //   ),
    // );
  }

  @override
  void dispose() {
    movieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> matches = context.watch<MoviesProvider>().matches;
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomAppBar('CINEMATOR', hasDrawer: true, hasSearch: true),
        body: Container(
          decoration: BoxDecoration(color: AppColors.bg),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchField(
                  controller: movieController,
                  onSearch: (value) => context
                      .read<MoviesProvider>()
                      .applyFilters(value, favoriteFilter),
                  onFavorite: (favorite) {
                    setState(() => favoriteFilter = favorite);
                    context.read<MoviesProvider>().applyFilters(
                      searchText,
                      favorite,
                    );
                  },
                ),
                SizedBox(height: 20),
                if (matches.isEmpty) Center(child: Text('No Results Found')),
                if (matches.isNotEmpty)
                  ...List.generate(
                    matches.length,
                    (index) => Column(
                      children: [
                        SizedBox(height: 5),
                        CustomMovieTile(
                          name: matches[index]['name']!,
                          genre: matches[index]['genre']!,
                          release: matches[index]['release']!,
                          isFavorite: matches[index]['favorite']!,
                          onTap: () => Navigator.of(context).push(
                            route(
                              MovieDetails(
                                name: matches[index]['name']!,
                                genre: matches[index]['genre']!,
                                release: matches[index]['release']!,
                                isFavorite: matches[index]['favorite']!,
                              ),
                            ),
                          ),
                          onFavorite: (value) {
                            if (value) {
                              context.read<MoviesProvider>().addToFavorites(
                                matches[index]['name']!,
                              );
                            } else {
                              context
                                  .read<MoviesProvider>()
                                  .removeFromFavorites(matches[index]['name']!);
                            }
                            context.read<MoviesProvider>().applyFilters(
                              movieController.text.trim(),
                              favoriteFilter,
                            );
                          },
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

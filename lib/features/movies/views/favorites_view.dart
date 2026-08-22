import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/movies/provider/movies_provider.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/views/movie_details.dart';
import 'package:task/widgets/custom_app_bar.dart';
import 'package:task/features/movies/widgets/custom_movie_tile.dart';
import 'package:task/widgets/search_field.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  TextEditingController movieController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<MoviesProvider>().applyFavoriteFilter(''),
    );
  }

  @override
  void dispose() {
    movieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> favorites = context
        .watch<MoviesProvider>()
        .favoriteMatches;
    return Scaffold(
      appBar: CustomAppBar('Favorites'),
      body: favorites.isEmpty
          ? Center(child: Text('No Favorites Added Yet'))
          : Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SearchField(
                      controller: movieController,
                      onSearch: (value) => context
                          .read<MoviesProvider>()
                          .applyFavoriteFilter(value),
                    ),
                    SizedBox(height: 20),
                    ...List.generate(
                      favorites.length,
                      (index) => Column(
                        children: [
                          SizedBox(height: 5),
                          CustomMovieTile(
                            name: favorites[index]['name']!,
                            genre: favorites[index]['genre']!,
                            release: favorites[index]['release']!,
                            isFavorite: favorites[index]['favorite']!,
                            onTap: () => Navigator.of(context).push(
                              route(
                                MovieDetails(
                                  name: favorites[index]['name']!,
                                  genre: favorites[index]['genre']!,
                                  release: favorites[index]['release']!,
                                  isFavorite: favorites[index]['favorite']!,
                                ),
                              ),
                            ),
                            onFavorite: (value) {
                              if (value) {
                                context.read<MoviesProvider>().addToFavorites(
                                  favorites[index]['name']!,
                                );
                              } else {
                                context
                                    .read<MoviesProvider>()
                                    .removeFromFavorites(
                                      favorites[index]['name']!,
                                    );
                              }
                              context
                                  .read<MoviesProvider>()
                                  .applyFavoriteFilter(searchText);
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
    );
  }
}

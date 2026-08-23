import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/movies/provider/favorites_provider.dart';
import 'package:task/features/movie_details/views/movie_details_view.dart';
import 'package:task/features/movies/widgets/custom_movie_card.dart';
import 'package:task/shared/custom_app_bar.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  void _openMovie(BuildContext context, int movieId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MovieDetailsView(movieId: movieId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const CustomAppBar('Favorites'),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white38,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Movies you add to favorites will show up here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.neutral, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return CustomMovieCard(
                  movie: movie,
                  onTap: () => _openMovie(context, movie.id),
                  isFavorite: true,
                  onFavoriteToggle: () =>
                      favoritesProvider.removeFavorite(movie.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:task/features/movies/provider/movies_provider.dart';
// import 'package:task/shared/material_page_route.dart';
// import 'package:task/views/movie_details.dart';
// import 'package:task/shared/custom_app_bar.dart';
// import 'package:task/features/movies/widgets/custom_movie_tile.dart';
// import 'package:task/widgets/search_field.dart';

// class FavoritesView extends StatefulWidget {
//   const FavoritesView({super.key});

//   @override
//   State<FavoritesView> createState() => _FavoritesViewState();
// }

// class _FavoritesViewState extends State<FavoritesView> {
//   TextEditingController movieController = TextEditingController();
//   String searchText = '';

//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback(
//     //   (_) => context.read<MoviesProvider>().applyFavoriteFilter(''),
//     // );
//   }

//   @override
//   void dispose() {
//     movieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Placeholder();
//     // List<Map<String, String>> favorites = context
//     //     .watch<MoviesProvider>()
//     //     .favoriteMatches;
//     // return Scaffold(
//     //   appBar: CustomAppBar('Favorites'),
//     //   body: favorites.isEmpty
//     //       ? Center(child: Text('No Favorites Added Yet'))
//     //       : Padding(
//     //           padding: EdgeInsets.all(16),
//     //           child: SingleChildScrollView(
//     //             child: Column(
//     //               children: [
//     //                 SearchField(
//     //                   controller: movieController,
//     //                   onSearch: (value) => context
//     //                       .read<MoviesProvider>()
//     //                       .applyFavoriteFilter(value),
//     //                 ),
//     //                 SizedBox(height: 20),
//     //                 ...List.generate(
//     //                   favorites.length,
//     //                   (index) => Column(
//     //                     children: [
//     //                       SizedBox(height: 5),
//     //                       CustomMovieTile(
//     //                         name: favorites[index]['name']!,
//     //                         genre: favorites[index]['genre']!,
//     //                         release: favorites[index]['release']!,
//     //                         isFavorite: favorites[index]['favorite']!,
//     //                         onTap: () => Navigator.of(context).push(
//     //                           route(
//     //                             MovieDetails(
//     //                               name: favorites[index]['name']!,
//     //                               genre: favorites[index]['genre']!,
//     //                               release: favorites[index]['release']!,
//     //                               isFavorite: favorites[index]['favorite']!,
//     //                             ),
//     //                           ),
//     //                         ),
//     //                         onFavorite: (value) {
//     //                           if (value) {
//     //                             context.read<MoviesProvider>().addToFavorites(
//     //                               favorites[index]['name']!,
//     //                             );
//     //                           } else {
//     //                             context
//     //                                 .read<MoviesProvider>()
//     //                                 .removeFromFavorites(
//     //                                   favorites[index]['name']!,
//     //                                 );
//     //                           }
//     //                           context
//     //                               .read<MoviesProvider>()
//     //                               .applyFavoriteFilter(searchText);
//     //                         },
//     //                       ),
//     //                       SizedBox(height: 5),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //           ),
//     //         ),
//     // );
//   }
// }

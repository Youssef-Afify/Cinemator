import 'package:flutter/material.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/features/movies/views/alternative_movie_list.dart';
import 'package:task/features/movies/views/favorites_view.dart';
import 'package:task/widgets/custom_app_bar.dart';
import 'package:task/widgets/custom_tile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Home'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTile(
                title: 'Movies',
                onTap: () => Navigator.of(context).pushNamed('/movies'),
              ),
              SizedBox(height: 20),
              CustomTile(
                title: 'Genres',
                onTap: () => Navigator.of(context).pushNamed('/genres'),
              ),
              SizedBox(height: 20),
              CustomTile(
                title: 'Alternate Movies',
                onTap: () =>
                    Navigator.of(context).push(route(AlternativeMovieList())),
              ),
              SizedBox(height: 20),
              CustomTile(
                title: 'Favorites',
                onTap: () => Navigator.of(context).push(route(FavoritesView())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

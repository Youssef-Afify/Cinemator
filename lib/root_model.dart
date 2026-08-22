import 'package:flutter/material.dart';
import 'package:task/features/movies/views/favorites_view.dart';
import 'package:task/features/movies/views/movies_view.dart';
import 'package:task/features/movies/views/popular_movies_view.dart';
import 'package:task/views/genres_view.dart';
import 'package:task/views/profile_view.dart';

class RootModel {
  final Widget view;
  final IconData selected;
  final IconData unselected;
  final String label;

  const RootModel({
    required this.view,
    required this.selected,
    required this.unselected,
    required this.label,
  });

  static List<BottomNavigationBarItem> bottomNavBarItems(int currentScreen) {
    return List.generate(rootModels.length, (index) {
      return BottomNavigationBarItem(
        icon: Icon(
          currentScreen == index
              ? rootModels[index].selected
              : rootModels[index].unselected,
        ),
        label: rootModels[index].label,
      );
    });
  }
}

const List<RootModel> rootModels = [
    RootModel(
      view: PopularMoviesPage(),
      selected: Icons.movie,
      unselected: Icons.movie_outlined,
      label: 'Movies',
    ),
    RootModel(
      view: GenresView(),
      selected: Icons.theater_comedy_rounded,
      unselected: Icons.theater_comedy_outlined,
      label: 'Genres',
    ),
    RootModel(
      view: FavoritesView(),
      selected: Icons.favorite,
      unselected: Icons.favorite_outline,
      label: 'Favorites',
    ),
    RootModel(
      view: ProfileView(),
      selected: Icons.person,
      unselected: Icons.person_outline,
      label: 'Profile',
    ),
  ];
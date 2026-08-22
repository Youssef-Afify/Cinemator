import 'package:flutter/material.dart';

List<Map<String, String>> movieList = [
  {
    'name': 'Inception',
    'genre': 'Science Fiction',
    'release': '2010',
    'favorite': 'false',
  },
  {
    'name': 'Interstellar',
    'genre': 'Science Fiction',
    'release': '2014',
    'favorite': 'false',
  },
  {
    'name': 'The Dark Knight',
    'genre': 'Superhero',
    'release': '2008',
    'favorite': 'false',
  },
  {
    'name': 'Avatar',
    'genre': 'Science Fiction',
    'release': '2009',
    'favorite': 'false',
  },
  {
    'name': 'The Matrix',
    'genre': 'Science Fiction',
    'release': '1999',
    'favorite': 'false',
  },
  {
    'name': 'Gladiator',
    'genre': 'History',
    'release': '2000',
    'favorite': 'false',
  },
];

class MoviesProvider extends ChangeNotifier {
  List<Map<String, String>> movies;
  List<Map<String, String>> matches;
  List<Map<String, String>> favorites;
  List<Map<String, String>> favoriteMatches;

  MoviesProvider()
    : movies = movieList,
      matches = movieList,
      favorites = [],
      favoriteMatches = [];

  void addToFavorites(String movieName) async {
    int index = movies.indexWhere((movie) => movie['name'] == movieName);
    movies[index]['favorite'] = 'true';
    favorites.add(Map.from(movies[index]));
    notifyListeners();
  }

  void removeFromFavorites(String movieName) async {
    int movieIndex = movies.indexWhere((movie) => movie['name'] == movieName);
    movies[movieIndex]['favorite'] = 'false';
    int favoriteIndex = favorites.indexWhere(
      (favorite) => favorite['name'] == movieName,
    );
    favorites.removeAt(favoriteIndex);
    notifyListeners();
  }

  void applyFilters(String searchText, bool favoriteFilter) {
    matches = movies.where((movie) {
      final bool getSearch = movie['name']!.toLowerCase().contains(
        searchText.toLowerCase(),
      );
      final bool getFavorite = !favoriteFilter || movie['favorite']! == 'true';
      return getSearch && getFavorite;
    }).toList();
    notifyListeners();
  }

  void applyFavoriteFilter(String searchText) {
    favoriteMatches = favorites.where((favorite) {
      final bool getSearch = favorite['name']!.toLowerCase().contains(
        searchText.toLowerCase(),
      );
      return getSearch;
    }).toList();
    notifyListeners();
  }
}

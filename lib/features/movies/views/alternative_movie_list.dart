import 'package:flutter/material.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/views/movie_details.dart';
import 'package:task/widgets/custom_app_bar.dart';
import 'package:task/features/movies/widgets/custom_movie_tile.dart';
import 'package:task/widgets/search_field.dart';

class AlternativeMovieList extends StatefulWidget {
  const AlternativeMovieList({super.key});

  @override
  State<AlternativeMovieList> createState() => _AlternativeMovieListState();
}

class _AlternativeMovieListState extends State<AlternativeMovieList> {
  TextEditingController movieController = TextEditingController();
  String searchText = '';
  bool favoriteFilter = false;
  
  List<Map<String, String>> movies = [
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
  List<Map<String, String>> matches = [];

  @override
  void initState() {
    super.initState();
    matches = movies;
  }

  void changeList(String value, bool fav) {
    setState(() {
      searchText = value.trim();
      favoriteFilter = fav;
      matches = movies.where((movie) {
        final bool getSearch = movie['name']!.toLowerCase().contains(
          searchText.toLowerCase(),
        );
        final bool getFavorite =
            !favoriteFilter || movie['favorite']! == 'true';
        return getSearch && getFavorite;
      }).toList();
    });
  }

  void toggleFavorite(int matchIndex, bool value) {
    final movieName = matches[matchIndex]['name']!;
    final movieIndex = movies.indexWhere((m) => m['name'] == movieName);
    setState(() {
      if (movieIndex != -1) {
        movies[movieIndex]['favorite'] = value.toString();
      }
      matches[matchIndex]['favorite'] = value.toString();
    });
    changeList(searchText, favoriteFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Alternative Movies'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchField(
                controller: movieController,
                onSearch: (value) => changeList(value, favoriteFilter),
                onFavorite: (favorite) => changeList(searchText, favorite),
              ),
              SizedBox(height: 20),
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
                      onFavorite: (value) => toggleFavorite(index, value),
                    ),
                    SizedBox(height: 5),
                    if (index < matches.length - 1) Divider(),
                    if (index < matches.length - 1) SizedBox(height: 5),
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

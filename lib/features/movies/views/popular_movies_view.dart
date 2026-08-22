import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/movies/data/movie_model.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TmdbProvider>().fetchPopularMovies();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TmdbProvider>().fetchPopularMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Consumer<TmdbProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchPopularMovies(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.movies.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.movies.length + (provider.hasMorePages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.movies.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final movie = provider.movies[index];
              return MovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: movie.posterPath != null
                ? Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 50),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 50),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.formattedRating,
                        style: const TextStyle(fontSize: 11),
                      ),
                      const Spacer(),
                      Text(
                        movie.releaseYear,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
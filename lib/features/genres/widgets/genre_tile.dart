import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/movies/provider/tmdb_provider.dart';

class GenreTile extends StatefulWidget {
  final GenreModel genre;
  final VoidCallback? onTap;

  const GenreTile({super.key, required this.genre, this.onTap});

  @override
  State<GenreTile> createState() => _GenreTileState();
}

class _GenreTileState extends State<GenreTile> {
  static final Map<int, String?> _backdropCache = {};

  String? _backdropUrl;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadBackdrop();
  }

  Future<void> _loadBackdrop() async {
    final genreId = widget.genre.id;

    if (_backdropCache.containsKey(genreId)) {
      setState(() {
        _backdropUrl = _backdropCache[genreId];
        _loaded = true;
      });
      return;
    }

    try {
      final repository = context.read<TmdbProvider>().repository;
      final response = await repository.getMoviesByGenre(genreId: genreId);
      final movie = response.results.isNotEmpty ? response.results.first : null;
      final url = (movie?.backdropUrl.isNotEmpty ?? false)
          ? movie!.backdropUrl
          : movie?.posterUrl;

      _backdropCache[genreId] = url;
      if (mounted) {
        setState(() {
          _backdropUrl = url;
          _loaded = true;
        });
      }
    } catch (_) {
      _backdropCache[genreId] = null;
      if (mounted) setState(() => _loaded = true);
    }
  }

  static const _fallbackPalette = [
    Color(0xFF2A1A3A),
    Color(0xFF3A1A1A),
    Color(0xFF0F2E2A),
    Color(0xFF2E2410),
    Color(0xFF1A2438),
  ];

  Color get _fallbackColor =>
      _fallbackPalette[widget.genre.id % _fallbackPalette.length];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: (_loaded && _backdropUrl != null)
                  ? Image.network(
                      _backdropUrl!,
                      key: ValueKey(_backdropUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          ColoredBox(color: _fallbackColor),
                    )
                  : ColoredBox(
                      key: const ValueKey('fallback'),
                      color: _fallbackColor,
                    ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.88),
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.genre.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

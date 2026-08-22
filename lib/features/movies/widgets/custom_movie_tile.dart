import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/movies/provider/movies_provider.dart';

class CustomMovieTile extends StatefulWidget {
  final String name;
  final String genre;
  final String release;
  final String isFavorite;
  final void Function()? onTap;
  final ValueChanged<bool> onFavorite;

  const CustomMovieTile({
    super.key,
    required this.name,
    required this.genre,
    required this.release,
    required this.isFavorite,
    this.onTap,
    required this.onFavorite,
  });

  @override
  State<CustomMovieTile> createState() => _CustomMovieTileState();
}

class _CustomMovieTileState extends State<CustomMovieTile> {
  bool favorite = false;

  @override
  void initState() {
    super.initState();
    favorite = bool.tryParse(widget.isFavorite) ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MoviesProvider>(context);
    final currentMovie = provider.movies.firstWhere(
      (movie) => movie['name'] == widget.name,
      orElse: () => {},
    );
    if (currentMovie.isNotEmpty) {
      favorite = bool.tryParse(currentMovie['favorite'] ?? 'false') ?? false;
    }
  }

  // @override
  // void didUpdateWidget(CustomMovieTile old) {
  //   super.didUpdateWidget(old);
  //   if (old.isFavorite != widget.isFavorite) {
  //     favorite = bool.tryParse(widget.isFavorite) ?? false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: AlignmentGeometry.centerStart,
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 117, 69, 69),
          border: BoxBorder.all(
            color: const Color.fromARGB(255, 80, 36, 36),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                favorite = !favorite;
                widget.onFavorite(favorite);
              }),
              child: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: const Color.fromARGB(255, 255, 0, 0),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  '${widget.genre} - ${widget.release}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_right, size: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

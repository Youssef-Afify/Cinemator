import 'package:flutter/material.dart';
import 'package:task/widgets/custom_app_bar.dart';

class MovieDetails extends StatelessWidget {
  final String name;
  final String genre;
  final String release;
  final String isFavorite;
  const MovieDetails({
    super.key,
    required this.name,
    required this.genre,
    required this.release,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Movie Details', goBack: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(name, style: TextStyle(color: Colors.black, fontSize: 22)),
              SizedBox(height: 5),
              Text(
                '$genre - $release',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              SizedBox(height: 10),
              Icon(
                isFavorite == 'true' ? Icons.favorite : Icons.favorite_border,
                color: Colors.red[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

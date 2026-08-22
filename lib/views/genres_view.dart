import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/widgets/custom_app_bar.dart';

class GenresView extends StatelessWidget {
  const GenresView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> genres = [
      'Action',
      'Comedy',
      'Drama',
      'Science Fiction',
      'Animation',
      'Horror',
      'History',
    ];
    return Scaffold(
      appBar: CustomAppBar('Genres'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemBuilder: ((context, index) {
            return Container(
              alignment: AlignmentGeometry.center,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: BoxBorder.all(
                  color: Colors.green[900]!,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                genres[index],
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }),
          itemCount: genres.length,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task/shared/custom_text.dart';

class GenreChip extends StatelessWidget {
  final String name;
  final Color color;

  const GenreChip({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomText(
        name,
        color: Colors.white,
        size: 12,
        weight: FontWeight.w700,
      ),
    );
  }
}

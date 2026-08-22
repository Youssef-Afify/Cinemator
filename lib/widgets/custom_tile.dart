import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final void Function()? onTap;
  const CustomTile({super.key, required this.title, this.onTap, this.width = double.infinity, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentGeometry.centerStart,
        padding: EdgeInsets.all(16),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          border: BoxBorder.all(
            color: Colors.green.shade900,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 22)),
            Icon(Icons.arrow_right, size: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

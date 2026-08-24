import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width;
  final double? height;
  final double? radius;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 150,
        height: height ?? 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius ?? 15),
        ),
        child: Center(child: CustomText(text, color: Colors.white, size: 18)),
      ),
    );
  }
}

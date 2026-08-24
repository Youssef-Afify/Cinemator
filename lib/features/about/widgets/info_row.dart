import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(label, color: AppColors.primary, size: 13.5),
        CustomText(
          value,
          color: Colors.white,
          size: 13.5,
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}

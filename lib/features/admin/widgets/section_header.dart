import 'package:flutter/widgets.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: CustomText(
        text,
        color: AppColors.secondary,
        size: 13,
        weight: FontWeight.w700,
      ),
    );
  }
}

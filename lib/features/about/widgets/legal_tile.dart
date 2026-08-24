import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class LegalTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const LegalTile({
    super.key,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(label, color: Colors.white, size: 14),
                Icon(Icons.chevron_right, color: AppColors.neutral, size: 18),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
      ],
    );
  }
}

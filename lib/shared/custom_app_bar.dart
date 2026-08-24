import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool goBack;
  final bool hasDrawer;
  const CustomAppBar(
    this.title, {
    super.key,
    this.goBack = false,
    this.hasDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: preferredSize.height,
      decoration: BoxDecoration(color: AppColors.bg),
      child: Stack(
        children: [
          Center(
            child: CustomText(
              title,
              color: AppColors.primary,
              size: 24,
              weight: FontWeight.w800,
              family: 'Manrope',
            ),
          ),
          if (goBack || hasDrawer)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: preferredSize.height,
                width: 20,
                child: GestureDetector(
                  onTap: goBack
                      ? Navigator.of(context).pop
                      : hasDrawer
                      ? () => Scaffold.of(context).openDrawer()
                      : null,
                  child: Icon(
                    hasDrawer
                        ? Icons.menu
                        : goBack
                        ? Icons.arrow_back
                        : null,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

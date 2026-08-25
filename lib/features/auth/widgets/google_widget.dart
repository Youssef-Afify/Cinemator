import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/shared/custom_text.dart';

class GoogleWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool isLoading;
  final bool? specificLoading;

  const GoogleWidget({
    super.key,
    this.onTap,
    this.isLoading = false,
    this.specificLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: isLoading
              ? const Color.fromARGB(164, 255, 255, 255)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: specificLoading ?? isLoading
              ? LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.white,
                  size: 24,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/google.svg',
                      width: 30,
                      height: 30,
                    ),
                    Gap(10),
                    CustomText('Google', color: AppColors.primary, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}

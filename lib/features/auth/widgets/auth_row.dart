import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/auth/provider/authentication_provider.dart';
import 'package:task/shared/custom_text.dart';

class AuthRow extends StatelessWidget {
  final String question;
  final String answer;
  final AuthEnum authEnum;

  const AuthRow({
    super.key,
    required this.question,
    required this.answer,
    required this.authEnum,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          question,
          color: AppColors.neutral,
          size: 16,
          family: 'Inter',
        ),
        Gap(10),
        GestureDetector(
          onTap: () =>
              context.read<AuthenticationProvider>().changeIndex(authEnum),
          child: CustomText(
            answer,
            color: AppColors.secondary,
            size: 16,
            family: 'Inter',
          ),
        ),
      ],
    );
  }
}

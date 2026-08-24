import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/shared/custom_text.dart';

class ErrorState extends StatelessWidget {
  final VoidCallback onBack;

  const ErrorState({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white54, size: 40),
          const Gap(12),
          const CustomText(
            'Could not load movie details',
            color: Colors.white70,
          ),
          const Gap(16),
          TextButton(onPressed: onBack, child: const CustomText('Go back')),
        ],
      ),
    );
  }
}

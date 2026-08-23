import 'package:flutter/material.dart';

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
          const SizedBox(height: 12),
          const Text(
            'Could not load movie details',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onBack, child: const Text('Go back')),
        ],
      ),
    );
  }
}

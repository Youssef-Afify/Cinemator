import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  final Widget child;

  const AboutCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
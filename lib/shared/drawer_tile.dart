import 'package:flutter/material.dart';
import 'package:task/shared/custom_text.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white, size: 20),
      title: CustomText(label, color: Colors.white, size: 15),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

InputDecoration decoration(String label, IconData icon) => InputDecoration(
  labelText: label,
  labelStyle: TextStyle(color: AppColors.neutral),
  prefixIcon: Icon(icon, color: AppColors.neutral, size: 20),
  filled: true,
  fillColor: const Color(0xFF1E1E1E),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF353534), width: 1.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
  ),
);

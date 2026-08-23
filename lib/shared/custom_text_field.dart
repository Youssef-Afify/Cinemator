import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.prefixIcon,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.enabled = true,
  });
  final String label;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isPassword;
  final bool enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  InputBorder _border([Color? color]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color ?? Color(0xff353534)),
  );

  Widget? suffixIcon() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          color: AppColors.neutral,
        ),
      );
    }
    return null;
  }

  Widget? prefixIcon() => widget.prefixIcon == null
      ? null
      : Icon(widget.prefixIcon, color: AppColors.neutral);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      cursorColor: AppColors.primary,
      style: TextStyle(
        color: widget.enabled ? Colors.white : const Color(0xff7A7A79),
      ),
      cursorHeight: 20.0,
      obscureText: _obscure,
      decoration: InputDecoration(
        prefixIcon: prefixIcon(),
        suffixIcon: suffixIcon(),
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.enabled ? AppColors.neutral : const Color(0xff7A7A79),
        ),
        filled: true,
        fillColor: widget.enabled
            ? const Color(0xff161616)
            : const Color(0xff111111),
        enabledBorder: _border(),
        focusedBorder: _border(AppColors.neutral),
        disabledBorder: _border(const Color(0xff2A2A29)),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }
}
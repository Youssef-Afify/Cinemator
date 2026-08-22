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
  });
  final String label;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isPassword;

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
          color: Color(0xffC8C6C6),
        ),
      );
    }
    return null;
  }

  Widget? prefixIcon() => widget.prefixIcon == null
      ? null
      : Icon(widget.prefixIcon, color: Color(0xffC8C6C6));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      cursorColor: AppColors.primary,
      style: TextStyle(color: Colors.white),
      cursorHeight: 20.0,
      obscureText: _obscure,
      decoration: InputDecoration(
        prefixIcon: prefixIcon(),
        suffixIcon: suffixIcon(),
        labelText: widget.label,
        labelStyle: TextStyle(color: Color(0xffC8C6C6)),
        filled: true,
        fillColor: const Color(0xff161616),
        enabledBorder: _border(),
        focusedBorder: _border(Color(0xffC8C6C6)),
        disabledBorder: _border(),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }
}

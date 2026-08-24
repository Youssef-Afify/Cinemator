import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final String? family;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText(
    this.data, {
    super.key,
    this.color,
    this.size,
    this.weight,
    this.family,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontFamily: family,
        overflow: overflow,
      ),
      maxLines: maxLines,
    );
  }
}

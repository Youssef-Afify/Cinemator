import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onSearch;
  final ValueChanged<bool>? onFavorite;
  const SearchField({
    super.key,
    this.controller,
    required this.onSearch,
    this.onFavorite,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: const Color(0xff353534)),
    );
    return Material(
      elevation: 3,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        controller: widget.controller,
        onChanged: (value) => widget.onSearch(value),
        cursorColor: AppColors.primary,
        cursorHeight: 20.0,
        style: TextStyle(color: AppColors.secondary),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff201F1F),
          prefixIcon: Icon(Icons.search, color: AppColors.secondary),
          hintText: 'Search...',
          hintStyle: TextStyle(color: AppColors.secondary),
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border,
          suffixIcon: widget.onFavorite != null
              ? GestureDetector(
                  onTap: () {
                    setState(() => favorite = !favorite);
                    if (widget.onFavorite != null) {
                      widget.onFavorite!(favorite);
                    }
                  },
                  child: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red[800],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onSearch;
  const SearchField({super.key, this.controller, required this.onSearch});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

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
        textInputAction: TextInputAction.done,
        cursorColor: AppColors.primary,
        cursorHeight: 20.0,
        focusNode: _searchFocusNode,
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
          suffixIcon:
              widget.controller != null && widget.controller!.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    widget.controller!.text = '';
                    widget.onSearch('');
                  },
                  child: Icon(Icons.close, color: AppColors.secondary),
                )
              : null,
        ),
      ),
    );
  }
}

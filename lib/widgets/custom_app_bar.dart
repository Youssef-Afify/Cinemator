import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';

AppBar customAppBar(String title) {
  return AppBar(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primary,
    centerTitle: true,
    title: Text(title),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool goBack;
  final bool hasSearch;
  final bool hasDrawer;
  const CustomAppBar(
    this.title, {
    super.key,
    this.goBack = false,
    this.hasSearch = false,
    this.hasDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: preferredSize.height,
      decoration: BoxDecoration(color: AppColors.bg),
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
          if (goBack || hasSearch || hasDrawer)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: preferredSize.height,
                    width: 20,
                    child: GestureDetector(
                      // onTap: Navigator.of(context).pop, TO EDIT
                      child: Icon(
                        hasDrawer
                            ? Icons.menu
                            : goBack
                            ? Icons.arrow_back
                            : null,
                        color: const Color(0xffE9BCB6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: preferredSize.height,
                    width: 20,
                    child: GestureDetector(
                      // onTap: Navigator.of(context).pop, TO EDIT
                      child: Icon(
                        hasSearch ? Icons.search : null,
                        color: const Color(0xffE9BCB6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

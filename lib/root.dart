import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/root_model.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController _controller;
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.bg),
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          rootModels.length,
          (index) => rootModels[index].view,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xff201F1F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.neutral,
          items: RootModel.bottomNavBarItems(currentScreen),
          currentIndex: currentScreen,
          onTap: (index) {
            setState(() => currentScreen = index);
            _controller.jumpToPage(currentScreen);
          },
        ),
      ),
    );
  }
}

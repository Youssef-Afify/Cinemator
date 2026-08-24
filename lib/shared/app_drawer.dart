import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/drawer_tile.dart';
import 'package:task/shared/logout_action.dart';
import 'package:task/features/about/views/about_page.dart';
import 'package:task/shared/material_page_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserProvider>().username;

    return Drawer(
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          username,
                          color: AppColors.primary,
                          size: 18,
                          weight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const Gap(2),
                        CustomText(
                          'Member',
                          color: AppColors.neutral,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            const Gap(8),
            DrawerTile(
              icon: Icons.info_outline,
              label: 'About Page',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(route(const AboutPage()));
              },
            ),
            DrawerTile(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                Navigator.of(context).pop();
                performLogout(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomText(
                'v${AppInfo.version}',
                color: AppColors.neutral,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

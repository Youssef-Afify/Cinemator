import 'package:flutter/material.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/about/widgets/about_card.dart';
import 'package:task/features/about/widgets/info_row.dart';
import 'package:task/features/about/widgets/legal_tile.dart';
import 'package:task/shared/custom_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.bg,
        bottom: CustomAppBar(AppInfo.name, goBack: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.local_movies_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppInfo.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'VERSION ${AppInfo.version} (BUILD ${AppInfo.buildNumber})',
              style: TextStyle(
                color: AppColors.neutral,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            AboutCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About The App',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${AppInfo.name} helps you discover, browse, and keep '
                    'track of movies using real data from TMDB — search '
                    'titles, explore by genre, and build a list of '
                    'favorites, all in one clean, distraction-free screen.',
                    style: TextStyle(
                      color: AppColors.neutral,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AboutCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.data_object_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Development',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const InfoRow(label: 'Framework', value: 'Flutter'),
                  const SizedBox(height: 10),
                  const InfoRow(label: 'Data Provider', value: 'TMDB API'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AboutCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.gavel_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Legal',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LegalTile(
                    label: 'Terms of Service',
                    onTap: () => _comingSoon(context),
                  ),
                  LegalTile(
                    label: 'Privacy Policy',
                    onTap: () => _comingSoon(context),
                  ),
                  LegalTile(
                    label: 'Open Source Licenses',
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: AppInfo.name,
                      applicationVersion: AppInfo.version,
                    ),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AboutCard(
              child: Column(
                children: [
                  const Text(
                    'Need Assistance?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Have a question or ran into an issue? Reach out and "
                    "we'll get back to you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.neutral,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _comingSoon(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CONTACT SUPPORT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

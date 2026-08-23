import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/shared/logout_action.dart';
import 'package:task/shared/custom_button.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    _usernameController = TextEditingController(text: userProvider.username);
    _emailController = TextEditingController(text: userProvider.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveInfo() {
    context.read<UserProvider>().changeInfo(
      newUsername: _usernameController.text,
    );
    FocusScope.of(context).unfocus();
  }

  void _logout() => performLogout(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              Gap(20),
              Text(
                context.watch<UserProvider>().username,
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              Gap(36),
              CustomTextField(
                label: 'Username',
                controller: _usernameController,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                enabled: false,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(text: 'Edit Info', onTap: _saveInfo),
                  CustomButton(text: 'Logout', onTap: _logout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
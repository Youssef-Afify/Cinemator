import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/utils/pref_helper.dart';
import 'package:task/core/utils/validators/name_validator.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/shared/logout_action.dart';
import 'package:task/shared/custom_button.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  bool _isProfileLoading = false;
  bool _isLogoutLoading = false;
  bool _isLoading = false;

  void startProfileLoading() {
    setState(() {
      _isProfileLoading = true;
      _isLogoutLoading = false;
      _isLoading = true;
    });
  }

  void startLogoutLoading() {
    setState(() {
      _isLogoutLoading = true;
      _isProfileLoading = false;
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isProfileLoading = false;
      _isLogoutLoading = false;
      _isLoading = false;
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;

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

  void _saveInfo() async {
    startProfileLoading();
    String name = _usernameController.text.trim();
    if (name.isEmpty) {
      name = 'N/A';
    }
    try {
      await auth.currentUser?.updateDisplayName(name);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      final userProvider = context.read<UserProvider>();
      userProvider.changeInfo(newUsername: name);
      await PrefHelper.saveSession(name, userProvider.email);
      _usernameController.text = name;
      stopLoading();
    } catch (e) {
      stopLoading();
      showMessage("something went wrong");
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logout() async {
    try {
      startLogoutLoading();
      await performLogout(context);
      stopLoading();
    } catch (e) {
      stopLoading();
      showMessage("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String username = context.watch<UserProvider>().username;
    final String profileIcon = context.watch<UserProvider>().profileIcon();

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Gap(48),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: CustomText(
                    profileIcon,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const Gap(20),
                CustomText(
                  username,
                  color: Colors.white,
                  size: 32,
                ),
                const Gap(36),
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    label: 'Username',
                    prefixIcon: Icons.person_outline,
                    validator: (name) => nameValidator(name),
                    controller: _usernameController,
                  ),
                ),
                const Gap(16),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  enabled: false,
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'Edit Info',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _saveInfo();
                        }
                      },
                      isLoading: _isLoading,
                      specificLoading: _isProfileLoading,
                    ),
                    CustomButton(
                      text: 'Logout',
                      onTap: _logout,
                      isLoading: _isLoading,
                      specificLoading: _isLogoutLoading,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

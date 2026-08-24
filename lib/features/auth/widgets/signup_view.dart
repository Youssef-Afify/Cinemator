import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/core/utils/validators/confirm_validator.dart';
import 'package:task/core/utils/validators/email_validator.dart';
import 'package:task/core/utils/validators/name_validator.dart';
import 'package:task/core/utils/validators/password_validator.dart';
import 'package:task/features/auth/widgets/login_view.dart';
import 'package:task/shared/custom_button.dart';
import 'package:task/core/constants/app_colors.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/auth.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie, color: AppColors.primary, size: 100),
              CustomText(
                AppInfo.name,
                color: AppColors.primary,
                size: 24,
                weight: FontWeight.w900,
                family: 'Manrope',
              ),
              CustomText(
                'Join the definitive cinema experience.',
                color: AppColors.neutral,
                size: 18,
                weight: FontWeight.w100,
                family: 'Inter',
              ),
              Gap(20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff201F1F),
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    color: const Color(0xff353534),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Name',
                        prefixIcon: Icons.person,
                        validator: (name) => nameValidator(name),
                        controller: _nameController,
                      ),
                      Gap(20),
                      CustomTextField(
                        label: 'Email',
                        prefixIcon: Icons.email_outlined,
                        validator: (email) => emailValidator(email),
                        controller: _emailController,
                      ),
                      Gap(20),
                      CustomTextField(
                        label: 'Password',
                        prefixIcon: Icons.lock,
                        validator: (password) => passwordValidator(password),
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      Gap(20),
                      CustomTextField(
                        label: 'Confirm Password',
                        prefixIcon: Icons.lock_reset_outlined,
                        validator: (confirm) =>
                            confirmValidator(confirm, _passwordController.text),
                        controller: _confirmController,
                        isPassword: true,
                      ),
                      Gap(30),
                      CustomButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<UserProvider>().changeInfo(
                              newUsername: _nameController.text.trim(),
                              newEmail: _emailController.text.trim(),
                            );
                            Navigator.of(
                              context,
                            ).pushReplacement(route(LoginView()));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    'Already have an account?',
                    color: AppColors.neutral,
                    size: 16,
                    family: 'Inter',
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () => context.read<AuthProvider>().changeIndex(
                      AuthEnum.login,
                    ),
                    child: CustomText(
                      'Login',
                      color: AppColors.secondary,
                      size: 16,
                      family: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

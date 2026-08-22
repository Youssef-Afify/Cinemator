import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/auth/provider/auth_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/root.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/core/utils/validators/email_validator.dart';
import 'package:task/core/utils/validators/password_validator.dart';
import 'package:task/widgets/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              Text(
                'CINEMATOR',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Sign in to continue your journey.',
                style: TextStyle(
                  color: AppColors.neutral,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
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
                      CustomButton(
                        text: 'Login',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<UserProvider>().changeInfo(
                              newEmail: _emailController.text.trim(),
                            );
                            Navigator.of(
                              context,
                            ).pushReplacement(route(Root()));
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
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: AppColors.neutral,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () => context.read<AuthProvider>().changeIndex(
                      AuthEnum.signup,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xffFFB4AA),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
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

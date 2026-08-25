import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/core/utils/validators/email_validator.dart';
import 'package:task/shared/custom_button.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/custom_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    try {
      await auth.sendPasswordResetEmail(email: email);
      showMessage("Password reset email sent, Please check you email");
      await Future.delayed(Duration(seconds: 1));
      setState(() => _isLoading = false);
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "email address is not valid";
          break;
        case 'user-not-found':
          message = "Account doesn't exist with this email";
          break;
        case 'too-many-requests':
          message = "Too many login attempts, try again after 1 min";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "something went wrong";
      }
      showMessage(message);
    } catch (e) {
      setState(() => _isLoading = false);
      showMessage("something went wrong");
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              Gap(10),
              CustomText(
                'Enter your email and we will send you a link to reset your password.',
                color: AppColors.neutral,
                size: 18,
                weight: FontWeight.w100,
                family: 'Inter',
                textAlign: TextAlign.center,
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
                      CustomButton(
                        width: 170,
                        text: 'Reset Password',
                        isLoading: _isLoading,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await resetPassword();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

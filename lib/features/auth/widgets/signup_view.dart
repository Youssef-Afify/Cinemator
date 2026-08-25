import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/auth/provider/authentication_provider.dart';
import 'package:task/features/auth/widgets/auth_row.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/core/utils/validators/confirm_validator.dart';
import 'package:task/core/utils/validators/email_validator.dart';
import 'package:task/core/utils/validators/name_validator.dart';
import 'package:task/core/utils/validators/password_validator.dart';
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

  bool _isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    setState(() => _isLoading = true);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
      }

      if (user != null && !user.emailVerified) {
        setState(() => _isLoading = false);
        showMessage("Registration Successful! Please verify your email");
        await user.sendEmailVerification();
        await Future.delayed(Duration(seconds: 1));
        if (!mounted) return;
        context.read<AuthenticationProvider>().changeIndex(AuthEnum.login);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "Account already exists";
          break;
        case 'invalid-email':
          message = "the email address is invalid";
          break;
        case 'weak-password':
          message = "the password is too weak";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "Something went wrong";
      }
      showMessage(message);
    } catch (e) {
      setState(() => _isLoading = false);
      showMessage('Something went worng, please try again later');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                        isLoading: _isLoading,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await signup();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20),
              AuthRow(
                question: 'Already have an account?',
                answer: 'Login',
                authEnum: AuthEnum.login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

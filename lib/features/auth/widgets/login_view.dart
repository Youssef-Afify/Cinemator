import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/core/constants/app_info.dart';
import 'package:task/features/auth/provider/authentication_provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/features/auth/views/forgot_password_view.dart';
import 'package:task/features/auth/widgets/auth_row.dart';
import 'package:task/features/auth/widgets/google_widget.dart';
import 'package:task/root.dart';
import 'package:task/shared/custom_text.dart';
import 'package:task/shared/custom_text_field.dart';
import 'package:task/shared/material_page_route.dart';
import 'package:task/core/utils/validators/email_validator.dart';
import 'package:task/core/utils/validators/password_validator.dart';
import 'package:task/shared/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginLoading = false;
  bool _isGoogleLoading = false;
  bool _isLoading = false;

  void startLoginLoading() {
    setState(() {
      _isLoginLoading = true;
      _isGoogleLoading = false;
      _isLoading = true;
    });
  }

  void startGoogleLoading() {
    setState(() {
      _isGoogleLoading = true;
      _isLoginLoading = false;
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isGoogleLoading = false;
      _isLoginLoading = false;
      _isLoading = false;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn google = GoogleSignIn.instance;

  Future<void> initializeGoogleSignIn() async {
    await google.initialize();
  }

  Future signInWithGoogle() async {
    try {
      startGoogleLoading();
      final GoogleSignInAccount googleUser = await google.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential credential = await auth.signInWithCredential(
        oAuthCredential,
      );
      final User? user = credential.user;
      if (user == null) {
        stopLoading();
        showMessage("Google sign in failed");
        return;
      }
      String? username = user.displayName;
      String? email = user.email;

      if (!mounted) return;
      context.read<UserProvider>().changeInfo(
        newUsername: username,
        newEmail: email,
      );
      stopLoading();
      Navigator.pushReplacement(context, route(const Root()));
    } on FirebaseAuthException catch (e) {
      stopLoading();
      showMessage("error: ${e.message ?? e.code}");
    } catch (e) {
      stopLoading();
      showMessage("Google sign in failed, please try again");
    }
  }

  Future<void> login() async {
    startLoginLoading();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = credential.user;
      if (user == null) {
        stopLoading();
        showMessage("Login failed, please try again");
        return;
      }
      if (!user.emailVerified) {
        await auth.signOut();
        stopLoading();
        showMessage("Please verify you email before logging in");
        return;
      }
      String? username = user.displayName;
      if (!mounted) return;
      context.read<UserProvider>().changeInfo(
        newUsername: username,
        newEmail: email,
      );
      stopLoading();
      Navigator.pushReplacement(context, route(const Root()));
    } on FirebaseAuthException catch (e) {
      stopLoading();
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "email address is not valid";
          break;
        case 'user-not-found':
          message = "Account doesn't exist with this email";
          break;
        case 'wrong-password':
          message = "Incorrect passowrd";
          break;
        case 'invalid-credential':
          message = "Invalid Email or Password";
          break;
        case 'user-disabled':
          message = "this account has been disabled";
          break;
        case 'too-many-requests':
          message = "Too many login attempts, try again after 1 min";
          break;
        case 'operation-not-allowed':
          message = "Email/Password Authentication is not enabled";
          break;
        default:
          message = e.message ?? "Login Failed";
      }
      showMessage(message);
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

  @override
  void initState() {
    super.initState();
    initializeGoogleSignIn();
  }

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
              CustomText(
                AppInfo.name,
                color: AppColors.primary,
                size: 24,
                weight: FontWeight.w900,
                family: 'Manrope',
              ),
              CustomText(
                'Sign in to continue your journey.',
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
                      Gap(15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            route(const ForgotPasswordView()),
                          ),
                          child: CustomText(
                            'Forgot Password?',
                            color: AppColors.secondary,
                            size: 14,
                            family: 'Inter',
                          ),
                        ),
                      ),
                      Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                            text: 'Login',
                            isLoading: _isLoading,
                            specificLoading: _isLoginLoading,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await login();
                              }
                            },
                          ),
                          GoogleWidget(
                            onTap: () async => await signInWithGoogle(),
                            isLoading: _isLoading,
                            specificLoading: _isGoogleLoading,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20),
              AuthRow(
                question: "Don't have an account?",
                answer: 'Sign Up',
                authEnum: AuthEnum.signup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

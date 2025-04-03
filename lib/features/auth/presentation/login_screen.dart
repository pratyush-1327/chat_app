// lib/screens/login_screen.dart
// import 'package:FlutChat/features/authentication/providers/auth_provider.dart';
import 'package:FlutChat/features/auth/provider/auth_provider.dart';
import 'package:FlutChat/features/chat/screens/chat_homepage.dart';
import 'package:FlutChat/features/auth/presentation/signup_screen.dart';
import 'package:FlutChat/features/auth/presentation/logfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FlutChat/screens/home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to FlutChat",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                labeltext: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              // SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  labeltext: 'Password',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 4.h),
              isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                            double.infinity, 50), // Make button wider
                      ),
                      onPressed: login,
                      child: Text(
                        'Log In',
                        style: TextStyle(fontSize: 18.sp), // Adjust font size
                      ),
                    ),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupScreen())),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .signIn(emailController.text, passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }
}

// lib/screens/login_screen.dart
// import 'package:FlutChat/features/authentication/providers/auth_provider.dart';
import 'package:FlutChat/features/auth/provider/auth_provider.dart';
import 'package:FlutChat/screens/home_screen.dart';
import 'package:FlutChat/features/auth/presentation/signup_screen.dart';
import 'package:FlutChat/screens/widgets/logfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void login() async {
    setState(() => isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .signIn(emailController.text, passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              labeltext: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 2.h),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              labeltext: 'Password',
            ),
            SizedBox(height: 4.h),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: const Text('Login')),
            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SignupScreen())),
              child: const Text("Don't have an account? Sign up"),
            )
          ],
        ),
      ),
    );
  }
}

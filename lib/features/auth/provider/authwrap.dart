import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/auth/provider/auth_provider.dart';
import 'package:FlutChat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return user != null ? const MainScreen() : const LoginScreen();
  }
}

import 'package:FlutChat/core/theme/util.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'firebase_options.dart';
import 'features/auth/provider/auth_provider.dart';
import 'screens/home_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        final brightness =
            View.of(context).platformDispatcher.platformBrightness;

        TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

        MaterialTheme theme = MaterialTheme(textTheme);
        return MaterialApp(
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          debugShowCheckedModeBanner: false,
          home: const AuthenticationWrapper(),
        );
      },
    );
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return user != null ? const HomeScreen() : const LoginScreen();
  }
}

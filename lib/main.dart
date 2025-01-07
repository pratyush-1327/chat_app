import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity, // For Android
    // appleProvider: AppleProvider.deviceCheck, // For iOS
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isSignedIn) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

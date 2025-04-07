import 'package:FlutChat/core/theme/util.dart';
import 'package:FlutChat/features/auth/provider/authwrap.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'firebase_options.dart';
import 'package:FlutChat/core/theme/theme_provider.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

        MaterialTheme theme = MaterialTheme(textTheme);
        return MaterialApp(
          theme: switch (themeMode) {
            ThemeMode.light => theme.light(),
            ThemeMode.dark => theme.dark(),
            ThemeMode.system =>
              View.of(context).platformDispatcher.platformBrightness ==
                      Brightness.light
                  ? theme.light()
                  : theme.dark(),
          },
          debugShowCheckedModeBanner: false,
          home: const AuthenticationWrapper(),
        );
      },
    );
  }
}

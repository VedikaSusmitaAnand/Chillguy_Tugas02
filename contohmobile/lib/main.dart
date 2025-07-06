import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import './screens/home_screen.dart';
import './screens/settings_page.dart';
import './screens/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode, // ✅ pakai static field
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zero Hunger',
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const FitrybeApp());
}

class FitrybeApp extends StatelessWidget {
  const FitrybeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fitrybe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'package:my_focus_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Focus Timer',
      theme: AppTheme.lightTheme,
      home: const WelcomePage(),
    );
  }
}
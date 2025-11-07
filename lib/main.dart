import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'pages/welcome_page.dart';
import 'package:my_focus_app/theme/app_theme.dart';

void main() {
  FlutterForegroundTask.initCommunicationPort();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
        child: MaterialApp(
          title: 'My Focus Timer',
          theme: AppTheme.lightTheme,
          home: const WelcomePage(),
        )
    );
  }
}
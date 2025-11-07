import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:my_focus_app/pages/timer_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
      //TODO if foreground service is already active, skip
    });
  }

  Future<void> _requestPermissions() async {
    final NotificationPermission notificationPermission =
    await FlutterForegroundTask.checkNotificationPermission();

    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    } else {
      print("notification permission granted");
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        print("will request ignore battery optimizations");
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      } else {
        print("is ignoring battery optimizations");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30.0,
          children: <Widget>[
            Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1.5
                  )
              ),
              child: const Icon(
                Icons.sentiment_very_satisfied,
                size: 100.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimerPage())
                  );
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)
                        )
                    )
                ),
                child: const Text('Begin working session'))
          ],
        ),
      ),
    );
  }
}

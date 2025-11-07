import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:my_focus_app/utils/formatters.dart';
import 'dart:async';

import '../utils/foreground_timer_task.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<StatefulWidget> createState() => _TimerPageState();
}

enum TimerState {
  focus,
  rest
}

class _TimerPageState extends State<TimerPage> {
  TimerState _currentTimerState = TimerState.focus;
  final _mainStopwatch = Stopwatch();
  Timer? _uiUpdateTimer;
  Duration _previousTime = Duration();

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
      _initTimerService();
    })

    _uiUpdateTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          if (_mainStopwatch.isRunning) {
            setState(() {});
          }
        });

    _mainStopwatch.start();
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  void _onReceiveTaskData(Object data) {
    //data is a map of all objects sent, String key, any type object value
    if (data is Map<String, dynamic>) {

    }
  }

  void _startFocus() {
    setState(() {
      _currentTimerState = TimerState.focus;
      _previousTime = _mainStopwatch.elapsed;
      _mainStopwatch.reset();
    });
  }

  void _startRest() {
    setState(() {
      _currentTimerState = TimerState.rest;
      _previousTime = _mainStopwatch.elapsed;
      _mainStopwatch.reset();
    });
  }

  void _initTimerService() {
    FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
            channelId: 'foreground_service',
            channelName: 'Foreground Service Notification',
            channelDescription: 'This notification appears when the foreground service is running.',
            onlyAlertOnce: true
        ),
        iosNotificationOptions: IOSNotificationOptions(
          showNotification: true,
          playSound: true
        ),
        foregroundTaskOptions: ForegroundTaskOptions(
            eventAction: ForegroundTaskEventAction.repeat(1000),
          // autoRunOnMyPackageReplaced: true
          // allowWakeLock: true
        )
    );
  }

  Future<ServiceRequestResult> _startTimerService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
          serviceId: 1337,
          notificationTitle: 'Foreground Service is running',
          notificationText: 'Tap to return to the app',
        notificationButtons: [
          const NotificationButton(id: 'hello', text: 'hello')
        ],
        notificationInitialRoute: '/',
        callback: startCallback,
      );
    }
  }

  Future<void> _requestPermissions() async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();

    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String previousText;
    String statusText;
    String mainButtonText;

    switch (_currentTimerState) {
      case TimerState.focus:
        previousText = "Last Rest";
        statusText = "Focusing";
        mainButtonText = "Take a Rest";
      case TimerState.rest:
        previousText = "Last Focus";
        statusText = "Resting";
        mainButtonText = "Start Focused Work";
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 1.0,
                    children: [
                      Text(previousText, style: Theme.of(context).textTheme.bodySmall),
                      Text(formatStopwatchInMinutesSeconds(_previousTime), style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                Container(
                  width: 250.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1.5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3.0,
                    children: [
                      Text('Current Block', style: Theme.of(context).textTheme.bodyLarge),
                      Text(formatStopwatchInMinutesSeconds(_mainStopwatch.elapsed), style: Theme.of(context).textTheme.displayLarge),
                      Text(statusText, style: Theme.of(context).textTheme.titleLarge)
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40.0),

            FilledButton(
                onPressed: () {
                  if (_currentTimerState == TimerState.focus) {
                    _startRest();
                  } else if (_currentTimerState == TimerState.rest) {
                    _startFocus();
                  }
                },
                child: Text(mainButtonText))
          ],
        ),
      ),
    );
  }
}
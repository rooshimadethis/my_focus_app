
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:my_focus_app/utils/formatters.dart';
import 'package:vibration/vibration.dart';

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
  Duration _currentTime = Duration();
  Duration _previousTime = Duration();

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    //This runs immediately after the UI has finished rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initTimerService();
      startTimerService();
    });

    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    _confettiController.dispose();
    super.dispose();
  }

  //TODO update UI based on timer from foreground task
  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey("newTime")) {
        setState(() {
          _currentTime = Duration(seconds: data["newTime"]);
        });
      }
    }
  }

  void _startFocus() {
    setState(() {
      _currentTimerState = TimerState.focus;
      _previousTime = _currentTime;
      _currentTime = Duration();
    });

    Map<String, dynamic> data = {
      "stateChange": {
        "newState": "startFocus"
      }
    };
    FlutterForegroundTask.sendDataToTask(data);
  }

  void _startRest() {
    setState(() {
      _currentTimerState = TimerState.rest;
      _previousTime = _currentTime;
      _currentTime = Duration();
    });

    Map<String, dynamic> data = {
      "stateChange": {
        "newState": "startRest"
      }
    };
    FlutterForegroundTask.sendDataToTask(data);
  }

  void endSession() {

    FlutterForegroundTask.stopService();
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
        break;
      case TimerState.rest:
        previousText = "Last Focus";
        statusText = "Resting";
        mainButtonText = "Start Focused Work";
        break;
    }

    return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                    onPressed: () async {
                      endSession();
                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate(pattern: [100, 100, 180, 100, 100, 400]);
                      }
                      _confettiController.play();
                    },
                    child: Text("End Session"))
              ],
            ),
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
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              spreadRadius: 2, // How far the shadow spreads
                              blurRadius: 10,  // How soft the shadow is
                              offset: Offset(0, 4), // Moves the shadow down a bit
                            ),
                          ]
                        ),
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
                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            color: Theme.of(context).colorScheme.surface
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 3.0,
                          children: [
                            Text('Current Block', style: Theme.of(context).textTheme.bodyLarge),
                            Text(formatStopwatchInMinutesSeconds(_currentTime), style: Theme.of(context).textTheme.displayLarge),
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
                        HapticFeedback.mediumImpact();
                      },
                      child: Text(mainButtonText))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi,
              emissionFrequency: 0.05,
              minimumSize: const Size(17, 25),
              maximumSize: const Size(35, 30),
              numberOfParticles: 20,
              gravity: 0.2,
              minBlastForce: 10,
              particleDrag: 0.05,
              colors: [Colors.blue, Colors.blueAccent, Colors.lightBlueAccent, Colors.deepPurpleAccent, Colors.deepPurple, Colors.pink, Colors.yellow],
            ),
          )
        ]
    );
  }
}
import 'package:flutter/material.dart';
import 'package:my_focus_app/utils/formatters.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();

    _uiUpdateTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {

        })

    _mainStopwatch.start();
  }

  void _startFocus() {
    setState(() {
      _currentTimerState = TimerState.focus;
    });
  }

  void _startRest() {
    setState(() {
      _currentTimerState = TimerState.rest;
    });
  }

  @override
  Widget build(BuildContext context) {
    String statusText;
    String mainButtonText;

    switch (_currentTimerState) {
      case TimerState.focus:
        statusText = "Focusing";
        mainButtonText = "Take a Rest";
      case TimerState.rest:
        statusText = "Resting";
        mainButtonText = "Start Focused Work";
    }

    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 20.0),
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
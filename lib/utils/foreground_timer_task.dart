
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'formatters.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTimerHandler());
}

class ForegroundTimerHandler extends TaskHandler {
  Stopwatch? _stopwatch;
  Timer? _timer;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _stopwatch = Stopwatch();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _timer?.cancel();
    _stopwatch?.stop();
    await FlutterForegroundTask.clearAllData();
  }

  //Send Data
  @override
  void onRepeatEvent(DateTime timestamp) {
    // can be used to send data back
    // FlutterForegroundTask.sendDataToMain(data)
  }

  //Receive Data
  @override
  void onReceiveData(Object data) {
    super.onReceiveData(data);

    if (data.runtimeType == String) {
      switch (data) {
        case "start":
          _stopwatch?.start();

          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            print("timer");
            if (_stopwatch?.isRunning ?? false) {
              FlutterForegroundTask.updateService(
                notificationTitle: "bruh wtf",
                notificationText: formatStopwatchInMinutesSeconds(_stopwatch!.elapsed)
              );
            }
          });
          break;
        case "reset":
          _stopwatch?.reset();
          break;
        case "stop":
          _stopwatch?.stop();
          break;
      }
    }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }

}
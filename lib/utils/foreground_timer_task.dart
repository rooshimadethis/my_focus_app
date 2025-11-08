
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'formatters.dart';

// --------- Foreground Service ---------
void initTimerService() {
  FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        // onlyAlertOnce: true,
        priority: NotificationPriority.HIGH,
        enableVibration: true,
        channelImportance: NotificationChannelImportance.HIGH,
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

Future<ServiceRequestResult> startTimerService() async {
  if (await FlutterForegroundTask.isRunningService) {
    return FlutterForegroundTask.restartService();
  } else {
    return FlutterForegroundTask.startService(
      serviceId: 1337,
      notificationTitle: '00:00',
      notificationText: 'Focusing',
      notificationIcon: const NotificationIcon(
          metaDataName: 'me.rooshi.my_focus_app.SIT_ICON'
      ),
      notificationButtons: [
        const NotificationButton(id: 'hello', text: 'hello')
      ],
      notificationInitialRoute: '/',
      callback: startCallback,
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTimerHandler());
}


// --------- Timer Functionality ---------
class ForegroundTimerHandler extends TaskHandler {
  Stopwatch? _stopwatch;
  Timer? _timer;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _stopwatch = Stopwatch();
    _stopwatch?.start();

    //This works as a test, but maybe repeatEvent would be better
    //This needs to update the notification and send data back to the UI
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        //Update Notification
        FlutterForegroundTask.updateService(
            notificationTitle: formatStopwatchInMinutesSeconds(
                _stopwatch!.elapsed)
        );
        //Update UI
        Map<String, dynamic> data = {
          "newTime": _stopwatch!.elapsed.inSeconds
        };
        FlutterForegroundTask.sendDataToMain(data);
    });
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
    //TODO will be called every second
  }

  //Receive Data
  @override
  void onReceiveData(Object data) {
    super.onReceiveData(data);

    if (data is Map<String, dynamic>) {
      if (data.containsKey("stateChange")) {
        _changeState(data["stateChange"]);
      }
    }
  }

  void _changeState(dynamic stateChangeData) {
    String newState = stateChangeData["newState"];
    switch (newState) {
      case "startFocus":
        if (_stopwatch!.isRunning) {
          _stopwatch?.reset();
        } else {
          _stopwatch?.start();
        }
        FlutterForegroundTask.updateService(
            notificationText: "Focusing"
        );
        break;
      case "startRest":
        if (_stopwatch!.isRunning) {
          _stopwatch?.reset();
        } else {
          _stopwatch?.start();
        }
        FlutterForegroundTask.updateService(
            notificationText: "Resting"
        );
        break;
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
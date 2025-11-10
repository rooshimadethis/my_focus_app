# my_focus_app

Focus/Pomodoro app specifically for me

## Fix

[] if the service is already running, jump to the timer view 
[] kill the service after 2 hours in either state
[] Open/start brain.fm
[] 2 app themes, 1 for focus and 1 for rest blue, green
[] Ignore battery optimization not working

[] custom notification for service
    - apparently flutter_foreground_task doesn't allow for it. If I want it later, 
        I would need to find another lib or implement it myself
[x] Service not running
[x] service notification not showing
- don't start service until notification request is accepted
- move to home page
[x] end session button which stops the foreground service
[x] vibrate on button click


## TODOs
[] Android Foreground activity
    [] Can manually implement it later
[] iOS Live Activity


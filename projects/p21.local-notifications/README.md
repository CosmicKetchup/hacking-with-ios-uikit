# Project 21: Local Notifications

### Personal Notes
- an app can remove any of its pending notifications by calling the `removeAllPendingNotificationRequests()` method of `UNNotificationCenter`
- add observer with name `UIApplication.willEnterForegroundNotification` to check for and respond to the application returning from background

### Additional Challenges
> 1. Update the code in `didReceive` so that it shows different instances of `UIAlertController` depending on which action identifier was passed in.
> 2. For a harder challenge, add a second `UNNotificationAction` to the alarm category of [**project 21**](#). Give it the title _“Remind me later”_, and make it call `scheduleLocal()` so that the same alert is shown in `24` hours. (For the purpose of these challenges, a time interval notification with `86400` seconds is good enough – that’s roughly how many seconds there are in a day, excluding summer time changes and leap seconds.)
> 3. And for an even harder challenge, update [**project 2**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p02.guess-the-flag/) so that it reminds players to come back and play every day. This means scheduling a week of notifications ahead of time, each of which launch the app. When the app is finally launched, make sure you call `removeAllPendingNotificationRequests()` to clear any un-shown alerts, then make new alerts for future days.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185242701-c6689618-340e-4c9b-ad82-d18b207d599f.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185242737-2782ecdc-7c6e-4d17-8ffa-a27b52f5bb66.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185242781-ddab5f1a-afbe-4e7f-a02f-eb77d7aa82b9.png" style="float:left; width: 30%; margin-left: 1%">

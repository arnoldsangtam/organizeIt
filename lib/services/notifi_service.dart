import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //create a new instance of the plugin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialise the plugin
  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    //request notification permission for android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  //when notification is tapped
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      if (payload == 'dismiss_action') {
        // Dismiss the alarm and cancel the notification
        await flutterLocalNotificationsPlugin
            .cancel(0); // Dismiss the notification
      }
    }
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Notifications',
        channelDescription: 'your channel description',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('squid_game'),
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false,
        ticker: 'ticker',
        actions: [
          // Dismiss Button
          AndroidNotificationAction(
            'dismiss_action',
            'Dismiss',
            //icon: Symbols.clear, // Optional: Add a dismiss icon to the button
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(
        sound: 'squid_game',
      ),
    );
  }

  //show notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledDate,
  }) async {
    try {
      print('DEBUG - ID is $id');
      print('DEBUG - $scheduledDate');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
      print('DEBUG - Notification Called');
    } catch (e, stackTrace) {
      print('DEBUG - Failed to schedule notification: $e');
      print('DEBUG: $stackTrace');
    }
  }

  //delete notification
  Future<void> deleteNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

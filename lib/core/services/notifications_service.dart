// // import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// class AwesomeNotificationsService {
//   static String channelKey = 'dms_ventures_channel';
//   static String channelName = 'DMS Ventures Notifications';
//   static Future<void> init() async {
//     try {
//       AwesomeNotifications().initialize(
//         '',
//         [
//           NotificationChannel(
//             channelKey: channelKey,
//             channelName: 'Water Reminder Notifications',
//             channelDescription: 'Notifications for daily water reminders',
//             defaultColor: Colors.blue,
//             importance: NotificationImportance.High,
//             ledColor: Colors.white,
//             enableVibration: true,
//             playSound: true,
//           )
//         ],
//       );

//       // Request permissions
//       bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//       if (!isAllowed) {
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//       debugPrint("[NOTIFICATIONS INITIALIZED]");
//     } catch (e) {
//       debugPrint("[ERROR] during notification init: $e");
//     }
//   }

//   static Future<void> triggerNotification(String title, String message) async {
//     try {
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//           channelKey: channelKey,
//           title: title,
//           body: message,
//           notificationLayout: NotificationLayout.Default,
//         ),
//       );
//       debugPrint("[NOTIFICATION TRIGGERED]");
//     } catch (e) {
//       debugPrint("[ERROR] during notification trigger: $e");
//     }
//   }
// }

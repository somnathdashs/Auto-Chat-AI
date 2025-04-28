import 'dart:async';
import 'dart:ui';

import 'package:auto_chat_ai/Backend/AINotification.dart';
import 'package:auto_chat_ai/Backend/Notification%20Services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ForgroundServices{
  final service = FlutterBackgroundService();
  
  Future<void> initializeService() async {
    final androidDetails = AndroidNotificationChannel(
      "BgService",
      'Background Task',
      description: 'To inform user about background task is running.',
      importance: Importance.max,
      showBadge:true,
      playSound: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidDetails);
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "BgService",
        autoStartOnBoot: true,
        initialNotificationTitle: 'Auto Chat AI ',
        initialNotificationContent: 'I am active to reply your message',
        foregroundServiceNotificationId: 1122445566,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        autoStart: true,
      ),
    );

    service.startService();

  }

  void StopService() async{
    var isRunning = await service.isRunning();
    if (isRunning){
      service.invoke("stopService");
    }
  }
}



@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  print('Background service running...');


  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('stopService').listen((event) async {
      if (await service.isForegroundService()){
        NotificationService.showNotification("Auto Chat AI", "You just stopped me ,now i can't to reply your messages.", true);
        service.stopSelf();

      }
    });
  }

  service.on('update').listen((event) {
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );
  });

  // Run your task once
  Future<void> runOnce() async {
    AI_Notifiyer ai_notifiyer = AI_Notifiyer();
    ai_notifiyer.start();
  }

  // Run the task
  runOnce().then((_) {
    print('Service is idle. Waiting for stop command...');
    // Service stays alive but idle
  });
}

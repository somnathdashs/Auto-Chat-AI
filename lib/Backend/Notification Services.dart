import 'dart:async';
import 'package:auto_chat_ai/Backend/AI.dart';
import 'package:auto_chat_ai/Backend/Localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:workmanager/workmanager.dart';

// Constants (You need to define these somewhere)
const String Whatsapp = "com.whatsapp";
const String WhatsappBusiness = "com.whatsapp.w4b"; // Example package name, correct if needed.

class NotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService();

  static Future initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification taps here
      },
    );
  }

  static showNotification(String title, String body, bool playSound) async {
    final androidDetails = AndroidNotificationDetails(
      'InformChannel',
      'Information',
      channelDescription: 'Notifies about Auto Chat AI status and replies.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformDetails,
    );
  }
}

// WorkManager callback
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await LocalStorage.initialize();
      final ai = AskGemini();
      NotificationService.initialize();
      await for (final event in NotificationListenerService.notificationsStream) {
        final apiKey = LocalStorage.getString(MyKey.apiKey.toString()) ?? "";
        final details = LocalStorage.getString(MyKey.details.toString()) ?? "";
        final isEnabledWhatsApp = LocalStorage.getBool(MyKey.Whatsapp.toString()) ?? false;
        final isEnabledWhatsAppBusiness = LocalStorage.getBool(MyKey.WhatsappBusiness.toString()) ?? false;

        final isWhatsAppNotification = event.packageName == Whatsapp ;
        final isWhatsAppBusinessNotification = event.packageName == WhatsappBusiness ;

        if (isWhatsAppBusinessNotification && isEnabledWhatsAppBusiness) {
          if (event.canReply! && !event.hasRemoved! && event.title!="You"){
            if (apiKey.isEmpty || details.isEmpty) {
              NotificationService.showNotification("Api kei or details is missing.","API key or your details are not found.",true);
              continue;
            }
            final conversationKey = MyKey.Conversesion.toString() + event.title!;
            final conversation = LocalStorage.getStringList(conversationKey) ?? [];
            int new_conversestion_start_length = ((conversation.length-11)>0)?conversation.length-11:0;

            final currentChat = "${event.title}: ${event.content}";
            print("$currentChat");
            conversation.add(currentChat);


            final reply = await ai.GetReply(event.title!, conversation, apiKey, details);
            conversation.add("The Person: $reply");

            print("Reply Sent: $reply");
            await event.sendReply(reply);
            LocalStorage.saveStringList(conversationKey, conversation.sublist(new_conversestion_start_length));
          }

        }

        if (isWhatsAppNotification && isEnabledWhatsApp) {
          if (event.canReply! && !event.hasRemoved!  && event.title!="You" ){
            if (apiKey.isEmpty || details.isEmpty) {
              NotificationService.showNotification("Api key or details is missing.","API key or your details are not found.",true);
              continue;
            }
            final conversationKey = MyKey.Conversesion.toString() + event.title!;
            final conversation = LocalStorage.getStringList(conversationKey) ?? [];
            int new_conversestion_start_length = ((conversation.length-11)>0)?conversation.length-11:0;

            final currentChat = "${event.title}: ${event.content}";
            conversation.add(currentChat);

            final reply = await ai.GetReply(event.title!, conversation, apiKey, details);
            conversation.add("The Person: $reply");

            print("Reply Sent: $reply");
            await event.sendReply(reply);
            LocalStorage.saveStringList(conversationKey, conversation.sublist(new_conversestion_start_length));
          }

        }

      }

    } catch (e) {
      print("Error in background task: $e");
    }

    return Future.value(true); // Always return true to signal task completion
  });
}


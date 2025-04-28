import 'dart:async';
import 'dart:core';

import 'package:auto_chat_ai/Backend/AI.dart';
import 'package:auto_chat_ai/Backend/Localstorage.dart';
import 'package:auto_chat_ai/Backend/Notification%20Services.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class AI_Notifiyer {
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  final String Whatsapp = "com.whatsapp";
  final String WhatsappBusiness = "com.whatsapp.w4b";
  late AskGemini AI;

  AI_Notifiyer(){
    NotificationService.initialize();
    AI = AskGemini();
    LocalStorage.initialize();
  }

  static Future<bool> isPermmit() async{
    return await NotificationListenerService.isPermissionGranted();
  }

  static Future<bool> AskPermmission() async{
    bool ispermission = await isPermmit();
    if(!ispermission){
      return await NotificationListenerService.requestPermission();
    }
    return true;
  }

  // void ForStart(){
  //   await for (final event in NotificationListenerService.notificationsStream) {
  //
  //   }


  void start(){
    _subscription = NotificationListenerService
        .notificationsStream
        .listen((event) {
          OnNotificationRecives(event);
    },onDone: (){
      NotificationService.showNotification("Auto Chat AI", "I am deactivated, i can't to reply your messages.", true);
    });
  }
  void stop(){
    _subscription?.cancel();
  }

  void OnNotificationRecives(ServiceNotificationEvent event){
    final isEnabledWhatsApp = LocalStorage.getBool(MyKey.Whatsapp.toString()) ?? false;
    final isEnabledWhatsAppBusiness = LocalStorage.getBool(MyKey.WhatsappBusiness.toString()) ?? false;
    final isWhatsAppNotification = event.packageName == Whatsapp ;
    final isWhatsAppBusinessNotification = event.packageName == WhatsappBusiness ;

    if((isWhatsAppBusinessNotification && isEnabledWhatsAppBusiness) || (isWhatsAppNotification && isEnabledWhatsApp)){
      AutoReplay(event);

    }else{
      if (isWhatsAppBusinessNotification || isWhatsAppNotification){
        final conversationKey = MyKey.Conversesion.toString() + event.packageName! + event.title!;
        final conversation = LocalStorage.getStringList(conversationKey) ?? [];
        int new_conversestion_start_length = ((conversation.length - 11) > 0)
            ? conversation.length - 11
            : 0;
        if (event.canReply! && !event.hasRemoved! ) {
          if  (event.title.toString().contains("You")){
            conversation.add("The Person: ${event.content}"+" Time:"+DateTime.now().toLocal().toIso8601String());
          }else{
            conversation.add("${event.title}: ${event.content}"+" Time:"+DateTime.now().toLocal().toIso8601String());
          }
          LocalStorage.saveStringList(conversationKey,
              conversation.sublist(new_conversestion_start_length));
        }
      }
    }
  }

  void AutoReplay(ServiceNotificationEvent event) async {
    if ((event.canReply!) && (!event.hasRemoved!) && (!event.title.toString().contains("You"))) {
      final apiKey = LocalStorage.getString(MyKey.apiKey.toString()) ?? "";
      final details = LocalStorage.getString(MyKey.details.toString()) ?? "";
      if (apiKey.isEmpty || details.isEmpty) {
        NotificationService.showNotification("API key or details is missing.",
            "API key or your details are not found.", true);
        return;
      }
      final conversationKey = MyKey.Conversesion.toString() + event.title!;
      final conversation = LocalStorage.getStringList(conversationKey) ?? [];
      int new_conversestion_start_length = ((conversation.length - 11) > 0)
          ? conversation.length - 11
          : 0;

      final currentChat = "${event.title}: ${event.content}"+" Time:"+DateTime.now().toLocal().toIso8601String();
      conversation.add(currentChat);

      final reply = await AI.GetReply(
          event.title!, conversation, apiKey, details);
      conversation.add("The Person: $reply"+" Time:"+DateTime.now().toLocal().toIso8601String());

      await event.sendReply(reply);
      LocalStorage.saveStringList(conversationKey,
          conversation.sublist(new_conversestion_start_length));
    }
  }



}
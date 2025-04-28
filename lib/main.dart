import 'dart:async';
import 'dart:developer';

import 'package:auto_chat_ai/Backend/ForgroundServies.dart';
import 'package:auto_chat_ai/Backend/Localstorage.dart';
import 'package:auto_chat_ai/Backend/Notification%20Services.dart';
import 'package:auto_chat_ai/Screen/Home.dart';
import 'package:auto_chat_ai/Screen/yourdataScreen.dart';
import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize WorkManager
  // Workmanager().initialize(
  //   callbackDispatcher, // Background task handler
  //   isInDebugMode: true, // Set true for debugging
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Home());
  }
}
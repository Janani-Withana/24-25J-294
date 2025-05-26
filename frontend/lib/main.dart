import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/core_feature/HomeScreen.dart';
import 'package:frontend/core_feature/login_screen';
import 'package:frontend/feature_scarecrow/screens/GateController.dart';
import 'package:frontend/feature_scarecrow/screens/ScarecrowController.dart';
import 'firebase_options.dart'; // Ensure this import exists
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:frontend/core_feature/HomeScreen.dart';
// import 'package:frontend/core_feature/LoginScreen.dart';

import 'package:frontend/feature_water_management/screens/MoistureScreen.dart';
import 'package:frontend/feature_chatbot/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Pass options properly
  );

    // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  runApp(
    DevicePreview(
      enabled: true, // Set to false for production
      builder: (context) => const MyApp(),
    ),
    //const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,

      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      
      home: HomeScreen(),
      //home: LoginScreen(),
      //home: const ChatScreen(),
      //home: MoistureScreen(),
      //home: ScarecrowController(),
      
    );
  }
}



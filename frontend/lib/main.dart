import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/core_feature/HomeScreen.dart';
import 'firebase_options.dart'; // Ensure this import exists
import 'package:frontend/feature_water_management/screens/MoistureScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: MoistureScreen(),
    );
  }
}



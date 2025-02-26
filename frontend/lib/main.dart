import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'feature_chatbot/screens/chat_screen.dart';
import 'core_feature/LoginScreen.dart';

void main() => runApp(
    DevicePreview(
        enabled: true, // Set to false for production
        builder: (context) =>
            const MyApp(), // Wrap your app with DevicePreview
      ),
  );


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const LoginScreen(),
    );
  }
}


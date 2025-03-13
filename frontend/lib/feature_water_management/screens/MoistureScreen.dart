// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class MoistureScreen extends StatefulWidget {
//   @override
//   _MoistureScreenState createState() => _MoistureScreenState();
// }

// class _MoistureScreenState extends State<MoistureScreen> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref().child('moisture1');
//   int moistureValue = 0;

//   @override
//   void initState() {
//     super.initState();
//     _database.onValue.listen((event) {
//       setState(() {
//         moistureValue = event.snapshot.value as int? ?? 0;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Moisture Level'),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.green[100],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Current Moisture Level',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 '$moistureValue',
//                 style: const TextStyle(
//                   fontSize: 40,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MoistureScreen extends StatefulWidget {
  @override
  _MoistureScreenState createState() => _MoistureScreenState();
}

class _MoistureScreenState extends State<MoistureScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late FlutterLocalNotificationsPlugin _localNotifications;
  
  int _moistureValue = 0;  // Store moisture value

  @override
  void initState() {
    super.initState();
    
    // Initialize local notifications
    _initializeNotifications();

    // Listen for changes in "moisture1" and update UI
    _database.child('moisture1').onValue.listen((event) {
      setState(() {
        _moistureValue = event.snapshot.value as int? ?? 0;
      });
    });

    // Listen for changes in "Detection" value and trigger notification
    _database.child('Detection').onValue.listen((event) {
      int detectionValue = event.snapshot.value as int? ?? 0;
      if (detectionValue == 1) {
        _sendNotification("Bird detected", "Scarecrow Moving");
      }
    });
  }

  void _initializeNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    
    _localNotifications.initialize(settings);
  }

  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moisture Level'), backgroundColor: Colors.green),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Moisture Level',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '$_moistureValue%', // Show real-time moisture1 value
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




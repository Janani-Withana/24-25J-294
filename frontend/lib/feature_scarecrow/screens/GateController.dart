import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';
 
class GateController extends StatefulWidget {
  @override
  _GateControllerState createState() => _GateControllerState();
}
 
class _GateControllerState extends State<GateController> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late FlutterLocalNotificationsPlugin _localNotifications;
 
  int gateUp = 0;
  int gateDown = 0;
  int gateAlreadyUp = 0;
  int gateAlreadyDown = 0;
  int noWater = 0;
 
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForGateChanges();
  }
 
  void _initializeNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();
 
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
 
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
 
    _localNotifications.initialize(settings);
  }
 
  void _listenForGateChanges() {
    _database.child('GateUp').onValue.listen((event) {
      setState(() {
        gateUp = event.snapshot.value as int? ?? 0;
      });
    });
 
    _database.child('GateDown').onValue.listen((event) {
      setState(() {
        gateDown = event.snapshot.value as int? ?? 0;
      });
    });
 
    _database.child('GateAlreadyUp').onValue.listen((event) {
      setState(() {
        gateAlreadyUp = event.snapshot.value as int? ?? 0;
      });
    });
 
    _database.child('GateAlreadyDown').onValue.listen((event) {
      setState(() {
        gateAlreadyDown = event.snapshot.value as int? ?? 0;
      });
    });
 
    _database.child('NoWater').onValue.listen((event) {
      setState(() {
        noWater = event.snapshot.value as int? ?? 0;
      });
 
      if (noWater == 1) {
        _sendNotification("Water Alert", "Cannel doesn't have water to open the gate.");
      }
    });
  }
 
  void _sendNotification(String title, String body) async {
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
 
  void _toggleGate(String key) {
    if (noWater == 1) {
      _sendNotification("Warning", "Cannot open gate, channel is dry!");
      return;
    }
 
    if (key == "GateUp") {
      _database.child("GateUp").set(1); // Set gate up
      _database.child("GateDown").set(0); // Ensure gate down is off
      _database.child("GateAlreadyUp").set(1);
      _database.child("GateAlreadyDown").set(0);
 
      // Auto-reset GateUp after 2 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _database.child("GateUp").set(0);
      });
 
    } else if (key == "GateDown") {
      _database.child("GateDown").set(1); // Set gate down
      _database.child("GateUp").set(0); // Ensure gate up is off
      _database.child("GateAlreadyDown").set(1);
      _database.child("GateAlreadyUp").set(0);
 
      // Auto-reset GateDown after 2 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _database.child("GateDown").set(0);
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/srigoviya_logo.png",
                    height: 30,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "Gate Controller",
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/images/watergate.png", // Replace with actual image path
                height: 150,
              ),
              const SizedBox(height: 30),
              _buildButton("Open Gate", "GateUp", gateUp),
              const SizedBox(height: 10),
              _buildButton("Close Gate", "GateDown", gateDown),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildButton(String text, String key, int currentValue) {
    return ElevatedButton(
      onPressed: () {
        _toggleGate(key);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: currentValue == 1 ? Colors.green.shade900 : Colors.grey.shade500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansSinhala(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
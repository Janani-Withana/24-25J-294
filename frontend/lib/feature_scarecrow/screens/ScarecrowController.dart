import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class ScarecrowController extends StatefulWidget {
  @override
  _ScarecrowControllerState createState() => _ScarecrowControllerState();
}

class _ScarecrowControllerState extends State<ScarecrowController> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  int moveScarecrow = 0;
  int sound = 0;
  int light = 0;

  @override
  void initState() {
    super.initState();
    _listenForChanges();
  }

  void _listenForChanges() {
    _database.child('MoveScareCrow').onValue.listen((event) {
      setState(() {
        moveScarecrow = event.snapshot.value as int? ?? 0;
      });
    });

    _database.child('Sound').onValue.listen((event) {
      setState(() {
        sound = event.snapshot.value as int? ?? 0;
      });
    });

    _database.child('light').onValue.listen((event) {
      setState(() {
        light = event.snapshot.value as int? ?? 0;
      });
    });
  }

  void _toggleValue(String key, int currentValue) {
    int newValue = currentValue == 0 ? 1 : 0;
    _database.child(key).set(newValue);
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
                  Image.asset(
                    'images/srigoviya_logo.png',
                    height: 30,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "Scarecrow Controller",
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'images/watergate.png', // Replace with actual image path
                height: 150,
              ),
              const SizedBox(height: 30),
              _buildButton("Moving", "MoveScareCrow", moveScarecrow),
              const SizedBox(height: 10),
              _buildButton("Sound", "Sound", sound),
              const SizedBox(height: 10),
              _buildButton("Light", "light", light),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, String key, int currentValue) {
    return ElevatedButton(
      onPressed: () {
        _toggleValue(key, currentValue);
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


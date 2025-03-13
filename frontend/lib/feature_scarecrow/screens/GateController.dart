import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class GateController extends StatefulWidget {
  @override
  _GateControllerState createState() => _GateControllerState();
}

class _GateControllerState extends State<GateController> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
                "Gate Controller",
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
              _buildButton("Open Gate"),
              const SizedBox(height: 10),
              _buildButton("Close Gate"),
              const SizedBox(height: 10),
              _buildButton("Stop Gate"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
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

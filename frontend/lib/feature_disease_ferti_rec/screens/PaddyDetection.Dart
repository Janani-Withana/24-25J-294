import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class PaddyDetection extends StatefulWidget {
  @override
  _PaddyDetectionState createState() => _PaddyDetectionState();
}

class _PaddyDetectionState extends State<PaddyDetection> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'images/srigoviya_logo.png', // Replace with actual logo asset
                    height: 30,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('images/profile.png'), // Replace with actual image
                  ),
                ],
              ),

              
              // Header Image
              Center(
                child: Image.asset(
                  'images/paddyDetectionMain.png',
                  height: 120,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Title Text
              Text(
                "ගොයම් තිරිකේශනය සහ මෝසම නිර්දේශන",
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Feature Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    featureCard(
                      iconPath: 'images/diseaseDetecton.png',
                      title: "රෝග හඳුනා ගැනීම",
                      buttonText: "\u2794",
                    ),
                    featureCard(
                      iconPath: 'images/Group146.png',
                      title: "ගොයම් නිරීක්ෂණය",
                      buttonText: "\u2794",
                    ),
                    featureCard(
                      iconPath: 'images/soil.png',
                      title: "පසෙහි ගුණාත්මක භාවය",
                      buttonText: "\u2794",
                    ),
                    featureCard(
                      iconPath: 'images/Group147.png',
                      title: "පොහොර නිර්දේශ ඉතිහාසය",
                      buttonText: "\u2794",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureCard({required String iconPath, required String title, required String buttonText}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
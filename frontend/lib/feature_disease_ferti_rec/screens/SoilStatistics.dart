import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class SoilStatistics extends StatefulWidget {
  @override
  _SoilStatisticsState createState() => _SoilStatisticsState();
}

class _SoilStatisticsState extends State<SoilStatistics> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "පසෙහි ගුණාත්මකභාවය",
                    style: GoogleFonts.notoSansSinhala(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildGauge("නයිට්රජන්", 12),
              _buildGauge("පොස්පරස්", 10),
              _buildGauge("පොටෑසියම්", 8),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  "දින - 2024 දෙසැම්බර් 11, ප.ව. 10.44",
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildButton("නැවත ගොයම් නිවෙස්කරණය", Colors.green),
              SizedBox(height: 10),
              _buildButton("යෝජිත පොහොර සහ යෙදීමට සුදුසු කාල බලන්න", Colors.green.shade700),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(String label, int value) {
    return Column(
      children: [
        Icon(Icons.speed, size: 100, color: Colors.black),
        Text(
          "$label - $value",
          style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: GoogleFonts.notoSansSinhala(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

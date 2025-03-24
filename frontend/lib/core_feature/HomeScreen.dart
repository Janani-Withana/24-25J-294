// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'NavBar.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),

//               // Top Row (Logo & Profile Icon)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Image.asset(
//                     'images/srigoviya_logo.png', // Replace with actual logo asset
//                     height: 30,
//                   ),
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage('images/profile.png'), // Replace with actual image
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               // Weather Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF92D093), Color(0xFFC8E6C9)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "29°",
//                           style: GoogleFonts.poppins(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           "H: 32°  L: 27°",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           "Egypt, Mansora",
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           "Cloudy",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Image.asset(
//                       'images/weather.png', // Replace with weather icon
//                       height: 160,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Main Features Title
//               Text(
//                 "Main Features",
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),

//               const SizedBox(height: 15),

//               // Feature Cards Grid
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   children: [
//                     featureCard(
//                       iconPath: 'images/diagnose.png',
//                       title: "Diagnose your crop",
//                       buttonText: "Diagnose Diseases",
                      
//                     ),
//                     featureCard(
//                       iconPath: 'images/soil.png',
//                       title: "Follow your soil status",
//                       buttonText: "Soil Status",
//                     ),
//                     featureCard(
//                       iconPath: 'images/water.png',
//                       title: "Control Water",
//                       buttonText: "Irrigation Control",
//                     ),
//                     featureCard(
//                       iconPath: 'images/chatbot.png',
//                       title: "ගොවි ගැටලු සඳහා පිළිතුරු",
//                       buttonText: "ගොවි ගුරු",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget featureCard({required String iconPath, required String title, required String buttonText}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFC8E6C9),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(iconPath, height: 40),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 buttonText,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:frontend/feature_chatbot/screens/chat_screen.dart';
import 'package:frontend/feature_disease_ferti_rec/screens/PaddyDetection.dart';
import 'package:frontend/feature_scarecrow/screens/GateController.dart';
import 'package:frontend/feature_scarecrow/screens/ScarecrowController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NavBar.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Top Row (Logo & Profile Icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/srigoviya_logo.png', // Replace with actual logo asset
                    height: 30,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/profile.png'), // Replace with actual image
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Weather Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92D093), Color(0xFFC8E6C9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "29°",
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "H: 32°  L: 24°",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Kaduwela",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Cloudy",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/weather.png', // Replace with weather icon
                      height: 160,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Main Features Title
              Text(
                " ප්‍රධාන විශේෂාංග",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Feature Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    featureCard(
                      iconPath: 'assets/images/diagnose.png',
                      title: "රෝග හඳුනා ගන්න",
                      buttonText: "රෝග විනිශ්චය",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaddyDetection()),
                        );
                      },
                    ),
                    featureCard(
                      iconPath: 'assets/images/scarecrow.png',
                      title: "පඹයා හසුරුවන්න",
                      buttonText: "සුහුරු පඹයා",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScarecrowController()),
                        );
                      },
                    ),
                    featureCard(
                      iconPath: 'assets/images/water.png',
                      title: "ජලය පාලනය කරන්න",
                      buttonText: "ජල පාලනය",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GateController()),
                        );
                      },
                    ),
                    featureCard(
                      iconPath: 'assets/images/chatbot.png',
                      title: "ගොවි ගැටලු සඳහා පිළිතුරු",
                      buttonText: "ගොවි ගුරු",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        );
                      },
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

  Widget featureCard({required String iconPath, required String title, required String buttonText, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

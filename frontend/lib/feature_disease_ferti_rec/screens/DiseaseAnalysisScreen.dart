// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core_feature/NavBar.dart';

// class DiseaseAnalysisScreen extends StatefulWidget {
//   final Uint8List? imageBytes;
//   final String? imagePath;

//   const DiseaseAnalysisScreen({Key? key, this.imageBytes, this.imagePath})
//       : super(key: key);

//   @override
//   _DiseaseAnalysisScreenState createState() => _DiseaseAnalysisScreenState();
// }

// class _DiseaseAnalysisScreenState extends State<DiseaseAnalysisScreen> {
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
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10),
//               // Header with Logo & Profile Picture
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Image.asset(
//                     'images/srigoviya_logo.png',
//                     height: 30,
//                   ),
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage('images/profile.png'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Image Preview Box
//               Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width *
//                       0.85, // Adjusted width
//                   height: 230, // Increased height
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25), // More rounded
//                     border: Border.all(color: Colors.grey, width: 2),
//                   ),
//                   child: widget.imageBytes != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(25),
//                           child: Image.memory(widget.imageBytes!,
//                               fit: BoxFit.cover),
//                         )
//                       : widget.imagePath != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(25),
//                               child: Image.file(File(widget.imagePath!),
//                                   fit: BoxFit.cover),
//                             )
//                           : Icon(Icons.image, size: 100, color: Colors.grey),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "රෝගය - කුළු රෝගය",
//                 style: GoogleFonts.notoSansSinhala(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "රෝග ලක්ෂණ",
//                   style: GoogleFonts.notoSansSinhala(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("• 1 ලක්ෂණය",
//                         style: GoogleFonts.notoSansSinhala(fontSize: 16)),
//                     Text("• 2 ලක්ෂණය",
//                         style: GoogleFonts.notoSansSinhala(fontSize: 16)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Next Step Button
//               ElevatedButton(
//                 onPressed: () {
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10, horizontal: 16), // Reduced size
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   "යෝජිත පොහොර සහ යෙදීමට සුදුසු කාල බලන්න",
//                   style: GoogleFonts.notoSansSinhala(
//                       fontSize: 14, color: Colors.white), // Reduced text size
//                   textAlign: TextAlign.center,
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
import 'dart:typed_data';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';
import 'FertilizerRecommendationScreen.dart';

class DiseaseAnalysisScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? imagePath;

  const DiseaseAnalysisScreen({Key? key, this.imageBytes, this.imagePath}) : super(key: key);

  @override
  _DiseaseAnalysisScreenState createState() => _DiseaseAnalysisScreenState();
}

class _DiseaseAnalysisScreenState extends State<DiseaseAnalysisScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("රෝග හඳුනා ගැනීම")),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           
              const SizedBox(height: 10),
              widget.imageBytes != null
                  ? Image.memory(widget.imageBytes!, height: 200, fit: BoxFit.cover)
                  : widget.imagePath != null
                      ? Image.file(File(widget.imagePath!), height: 200, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                "රෝගය - කුළු රෝගය",
                style: GoogleFonts.notoSansSinhala(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "රෝග ලක්ෂණ",
                  style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• 1 ලක්ෂණය", style: GoogleFonts.notoSansSinhala(fontSize: 16)),
                    Text("• 2 ලක්ෂණය", style: GoogleFonts.notoSansSinhala(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FertilizerRecommendationScreen(
                        imageBytes: widget.imageBytes,
                        imagePath: widget.imagePath,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4BA26A),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "යෝජිත පොහොර සහ යෙදීමට සුදුසු කාල බලන්න",
                  style: GoogleFonts.notoSansSinhala(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

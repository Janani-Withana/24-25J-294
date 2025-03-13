// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:google_fonts/google_fonts.dart';

// class FertilizerRecommendationScreen extends StatefulWidget {
//   final Uint8List? imageBytes;
//   final String? imagePath;

//   const FertilizerRecommendationScreen({Key? key, this.imageBytes, this.imagePath}) : super(key: key);

//   @override
//   _FertilizerRecommendationScreenState createState() => _FertilizerRecommendationScreenState();
// }

// class _FertilizerRecommendationScreenState extends State<FertilizerRecommendationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("යෝජිත පොහොර සහ යෙදීමට සුදුසු කාල")),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10),
//               // Display Image
//               widget.imageBytes != null
//                   ? Image.memory(widget.imageBytes!, height: 200, fit: BoxFit.cover)
//                   : widget.imagePath != null
//                       ? Image.file(File(widget.imagePath!), height: 200, fit: BoxFit.cover)
//                       : const Icon(Icons.image, size: 100, color: Colors.grey),
//               const SizedBox(height: 20),

//               // Fertilizer Recommendation Text
//               // Text(
//               //   "යෝජිත පොහොර",
//               //   style: GoogleFonts.notoSansSinhala(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//               // ),
//               // const SizedBox(height: 10),

//               // Fertilizer Details
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "යෝජිත පොහොර",
//                       style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("• පෝෂක 01 - 12 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                     Text("• පෝෂක 02 - 16 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                     Text("• පෝෂක 03 - 5 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Suitable Dates & Times Container
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "යෙදීමට සුදුසු දිනයන් සහ වේලාවන්",
//                       style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("• 2024 දෙසැම්බර් 12 - පෙ.ව. 9.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                     Text("• 2024 දෙසැම්බර් 12 - පෙ.ව. 4.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                     Text("• 2024 දෙසැම්බර් 13 - පෙ.ව. 9.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Date & Time
//               Text(
//                 "දින - 2024 දෙසැම්බර් 11, ප.ව. 10.44",
//                 style: GoogleFonts.notoSansSinhala(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),

//               // Navigation Button
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4BA26A)),
//                 child: Text("නැවත ගොයම් නිවෙස්කරණය", style: GoogleFonts.notoSansSinhala(fontSize: 14, color: Colors.white)),
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

class FertilizerRecommendationScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? imagePath;

  const FertilizerRecommendationScreen({Key? key, this.imageBytes, this.imagePath}) : super(key: key);

  @override
  _FertilizerRecommendationScreenState createState() => _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState extends State<FertilizerRecommendationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("යෝජිත පොහොර සහ යෙදීමට සුදුසු කාල")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Ensures equal space on both sides
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Display Image
                  widget.imageBytes != null
                      ? Image.memory(widget.imageBytes!, height: 200, fit: BoxFit.cover)
                      : widget.imagePath != null
                          ? Image.file(File(widget.imagePath!), height: 200, fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),

                  // Fertilizer Details
                  SizedBox(
                    width: double.infinity, // Ensures full width
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "යෝජිත පොහොර",
                            style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("• පෝෂක 01 - 12 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                          Text("• පෝෂක 02 - 16 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                          Text("• පෝෂක 03 - 5 අක්කරයට කිලෝග්‍රෑම්", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Suitable Dates & Times Container
                  SizedBox(
                    width: double.infinity, // Ensures full width
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "යෙදීමට සුදුසු දිනයන් සහ වේලාවන්",
                            style: GoogleFonts.notoSansSinhala(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("• 2024 දෙසැම්බර් 12 - පෙ.ව. 9.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                          Text("• 2024 දෙසැම්බර් 12 - පෙ.ව. 4.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                          Text("• 2024 දෙසැම්බර් 13 - පෙ.ව. 9.00", style: GoogleFonts.notoSansSinhala(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date & Time
                  Text(
                    "දින - 2024 දෙසැම්බර් 11, ප.ව. 10.44",
                    style: GoogleFonts.notoSansSinhala(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Navigation Button
                  SizedBox(
                    width: double.infinity, // Ensures button is centered properly
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4BA26A)),
                      child: Text("නැවත ගොයම් නිවෙස්කරණය", style: GoogleFonts.notoSansSinhala(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

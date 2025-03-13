// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core_feature/NavBar.dart';

// class PaddyObservation extends StatefulWidget {
//   @override
//   _PaddyObservationState createState() => _PaddyObservationState();
// }

// class _PaddyObservationState extends State<PaddyObservation> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<String> dates = [
//     "05/01/2024",
//     "04/01/2024",
//     "03/01/2024",
//     "02/01/2024",
//     "01/01/2024",
//     "01/01/2024"
//   ];

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
//               const SizedBox(height: 30),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Row(
//                   children: [
//                     const Icon(Icons.arrow_back, color: Colors.black87),
//                     const SizedBox(width: 10),
//                     Text(
//                       "ගොයම් නිරීක්ෂණ",
//                       style: GoogleFonts.notoSansSinhala(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: dates.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: AssetImage('images/paddy.png'),
//                           radius: 20,
//                         ),
//                         title: Text(
//                           dates[index],
//                           style: GoogleFonts.notoSansSinhala(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.green),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: const BorderSide(color: Colors.grey, width: 0.5),
//                         ),
//                       ),
//                     );
//                   },
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
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';
import 'ObservationDetail.dart';

class PaddyObservation extends StatefulWidget {
  @override
  _PaddyObservationState createState() => _PaddyObservationState();
}

class _PaddyObservationState extends State<PaddyObservation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> dates = [
    "05/01/2024",
    "04/01/2024",
    "03/01/2024",
    "02/01/2024",
    "01/01/2024",
    "01/01/2024"
  ];

  final String defaultImagePath = 'images/paddy.png';

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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black87),
                    const SizedBox(width: 10),
                    Text(
                      "ගොයම් නිරීක්ෂණ",
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObservationDetail(date: dates[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(defaultImagePath),
                            radius: 20,
                          ),
                          title: Text(
                            dates[index],
                            style: GoogleFonts.notoSansSinhala(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

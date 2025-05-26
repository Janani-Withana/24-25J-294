import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class GateController extends StatefulWidget {
  @override
  _GateControllerState createState() => _GateControllerState();
}

class _GateControllerState extends State<GateController> with TickerProviderStateMixin {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late FlutterLocalNotificationsPlugin _localNotifications;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  int gateUp = 0;
  int gateDown = 0;
  int gateAlreadyUp = 0;
  int gateAlreadyDown = 0;
  int noWater = 0;

  // String waterStatus = "Loading...";
  int moisture1 = 0;
  int moisture2 = 0;
  int moisture = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeNotifications();
    _listenForGateChanges();
    _listenForMoistureChanges();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
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
        _sendNotification("Water Alert", "Channel doesn't have water to open the gate.");
      }
    });
  }

  void _listenForMoistureChanges() {
    _database.child('moisture').onValue.listen((event) {
      int moistureValue = event.snapshot.value as int? ?? 0;
      setState(() {
        // waterStatus = (moistureValue == 0) ? "WaterIn" : "No Water";
        moisture = event.snapshot.value as int? ?? 0;
      });
    });

    _database.child('moisture1').onValue.listen((event) {
      setState(() {
        moisture1 = event.snapshot.value as int? ?? 0;
      });
    });

    _database.child('moisture2').onValue.listen((event) {
      setState(() {
        moisture2 = event.snapshot.value as int? ?? 0;
      });
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
      _database.child("GateUp").set(1);
      _database.child("GateDown").set(0);
      _database.child("GateAlreadyUp").set(1);
      _database.child("GateAlreadyDown").set(0);

      Future.delayed(const Duration(seconds: 5), () {
        _database.child("GateUp").set(0);
      });

    } else if (key == "GateDown") {
      _database.child("GateDown").set(1);
      _database.child("GateUp").set(0);
      _database.child("GateAlreadyDown").set(1);
      _database.child("GateAlreadyUp").set(0);

      Future.delayed(const Duration(seconds: 5), () {
        _database.child("GateDown").set(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildModernHeader(),
              SlideTransition(
                position: _slideAnimation,
                child: _buildGateControllerUI(),
              ),
              const SizedBox(height: 20),
              _buildMoistureSensorUI(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade600,
            Colors.green.shade800,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  'assets/images/srigoviya_logo.png',
                  height: 25,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "ගේට්ටු පාලනය",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ජල කළමනාකරණ පද්ධතිය",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGateControllerUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade100,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/watergate.png',
                          height: 120,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                _buildStatusIndicator(),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: _buildModernButton("විවෘත කරන්න", "GateUp", gateUp, Icons.keyboard_arrow_up)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildModernButton("වසන්න ", "GateDown", gateDown, Icons.keyboard_arrow_down)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    bool isActive = gateUp == 1 || gateDown == 1;
    Color statusColor = noWater == 1 ? Colors.red : (isActive ? Colors.orange : Colors.green);
    String statusText = noWater == 1 ? "No Water" : (isActive ? "ක්‍රියා වෙමින් පවතී" : "ක්‍රියා කරවීමට සූදානම්");
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            statusText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoistureSensorUI() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade700],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sensors, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  "ජල සංවේදක අගයන්",
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildModernSensorCard("$moisture", "සංවේදක I\n(ඇල)","",Icons.water)),
                const SizedBox(width: 15),
                Expanded(child: _buildModernSensorCard("$moisture1 ", "සංවේදක II\n(කුඹුර)", "", Icons.grass)),
                const SizedBox(width: 15),
                Expanded(child: _buildModernSensorCard("$moisture2 ", "සංවේදක III\n(කුඹුර)", "", Icons.grass)),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildModernButton(String text, String key, int currentValue, IconData icon) {
    bool isActive = currentValue == 1;
    
    return GestureDetector(
      onTap: () => _toggleGate(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive 
              ? [Colors.green.shade600, Colors.green.shade800]
              : [Colors.grey.shade400, Colors.grey.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.green.shade200 : Colors.grey.shade300,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSensorCard(String value, String label, String status, IconData icon) {
    Color cardColor = status == "No Water" ? Colors.red.shade50 : Colors.green.shade50;
    Color iconColor = status == "No Water" ? Colors.red : Colors.green.shade600;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansSinhala(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == "No Water" ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
     ),
);
}
}


// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core_feature/NavBar.dart';
 
// class GateController extends StatefulWidget {
//   @override
//   _GateControllerState createState() => _GateControllerState();
// }
 
// class _GateControllerState extends State<GateController> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//   late FlutterLocalNotificationsPlugin _localNotifications;
 
//   int gateUp = 0;
//   int gateDown = 0;
//   int gateAlreadyUp = 0;
//   int gateAlreadyDown = 0;
//   int noWater = 0;
 
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _listenForGateChanges();
//   }
 
//   void _initializeNotifications() {
//     _localNotifications = FlutterLocalNotificationsPlugin();
 
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
 
//     const InitializationSettings settings =
//         InitializationSettings(android: androidSettings);
 
//     _localNotifications.initialize(settings);
//   }
 
//   void _listenForGateChanges() {
//     _database.child('GateUp').onValue.listen((event) {
//       setState(() {
//         gateUp = event.snapshot.value as int? ?? 0;
//       });
//     });
 
//     _database.child('GateDown').onValue.listen((event) {
//       setState(() {
//         gateDown = event.snapshot.value as int? ?? 0;
//       });
//     });
 
//     _database.child('GateAlreadyUp').onValue.listen((event) {
//       setState(() {
//         gateAlreadyUp = event.snapshot.value as int? ?? 0;
//       });
//     });
 
//     _database.child('GateAlreadyDown').onValue.listen((event) {
//       setState(() {
//         gateAlreadyDown = event.snapshot.value as int? ?? 0;
//       });
//     });
 
//     _database.child('NoWater').onValue.listen((event) {
//       setState(() {
//         noWater = event.snapshot.value as int? ?? 0;
//       });
 
//       if (noWater == 1) {
//         _sendNotification("Water Alert", "Cannel doesn't have water to open the gate.");
//       }
//     });
//   }
 
//   void _sendNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'channel_id', 'channel_name',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
 
//     const NotificationDetails details =
//         NotificationDetails(android: androidDetails);
 
//     await _localNotifications.show(0, title, body, details);
//   }
 
//   void _toggleGate(String key) {
//     if (noWater == 1) {
//       _sendNotification("Warning", "Cannot open gate, channel is dry!");
//       return;
//     }
 
//     if (key == "GateUp") {
//       _database.child("GateUp").set(1); // Set gate up
//       _database.child("GateDown").set(0); // Ensure gate down is off
//       _database.child("GateAlreadyUp").set(1);
//       _database.child("GateAlreadyDown").set(0);
 
//       // Auto-reset GateUp after 2 seconds
//       Future.delayed(const Duration(seconds: 5), () {
//         _database.child("GateUp").set(0);
//       });
 
//     } else if (key == "GateDown") {
//       _database.child("GateDown").set(1); // Set gate down
//       _database.child("GateUp").set(0); // Ensure gate up is off
//       _database.child("GateAlreadyDown").set(1);
//       _database.child("GateAlreadyUp").set(0);
 
//       // Auto-reset GateDown after 2 seconds
//       Future.delayed(const Duration(seconds: 5), () {
//         _database.child("GateDown").set(0);
//       });
//     }
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: 0,
//         onItemTapped: (index) {},
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Image.asset("assets/images/srigoviya_logo.png",
//                     height: 30,
//                   ),
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage("assets/images/profile.png"),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Text(
//                 "Gate Controller",
//                 style: GoogleFonts.notoSansSinhala(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green.shade900,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Image.asset(
//                 "assets/images/watergate.png", // Replace with actual image path
//                 height: 150,
//               ),
//               const SizedBox(height: 30),
//               _buildButton("Open Gate", "GateUp", gateUp),
//               const SizedBox(height: 10),
//               _buildButton("Close Gate", "GateDown", gateDown),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
 
//   Widget _buildButton(String text, String key, int currentValue) {
//     return ElevatedButton(
//       onPressed: () {
//         _toggleGate(key);
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: currentValue == 1 ? Colors.green.shade900 : Colors.grey.shade500,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.notoSansSinhala(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
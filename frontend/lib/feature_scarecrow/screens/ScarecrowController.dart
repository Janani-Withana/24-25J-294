import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core_feature/NavBar.dart';

class ScarecrowController extends StatefulWidget {
  @override
  _ScarecrowControllerState createState() => _ScarecrowControllerState();
}

class _ScarecrowControllerState extends State<ScarecrowController> with TickerProviderStateMixin {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late FlutterLocalNotificationsPlugin _localNotifications;
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  int moveScarecrow = 0;
  int sound = 0;
  int light = 0;
  bool detectionAlert = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeNotifications();
    _listenForChanges();
  }

  void _initializeAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _bounceController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
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

  void _listenForChanges() {
    _database.child('MoveScareCrow').onValue.listen((event) {
      setState(() {
        moveScarecrow = event.snapshot.value as int? ?? 0;
      });
      if (moveScarecrow == 1) {
        _rotationController.forward().then(() {
          _rotationController.reset();
        } as FutureOr Function(void value));
      }
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

    _database.child('Detection').onValue.listen((event) {
      int detectionValue = event.snapshot.value as int? ?? 0;
      if (detectionValue == 1) {
        setState(() {
          detectionAlert = true;
        });
        _sendNotification("Bird detected", "Scarecrow Moving");
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              detectionAlert = false;
            });
          }
        });
      }
    });
  }

  Future<void> _sendNotification(String title, String body) async {
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

  void _toggleValue(String key, int currentValue) {
    int newValue = currentValue == 0 ? 1 : 0;
    _database.child(key).set(newValue);
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
              ScaleTransition(
                scale: _bounceAnimation,
                child: _buildScarecrowControllerUI(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
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
          // Fixed the title section to prevent overflow
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "පඹයා හැසිරවීම",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "කුරුල්ලන් හඳුනා ගැනීම හා පාලනය",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (detectionAlert) ...[
            const SizedBox(height: 15),
            _buildDetectionAlert(),
          ],
        ],
      ),
    );
  }

  Widget _buildDetectionAlert() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Bird Detected! Scarecrow Active",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScarecrowControllerUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Container(
        width: double.infinity,
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
            _buildScarecrowDisplay(),
            const SizedBox(height: 40),
            _buildStatusSection(),
            const SizedBox(height: 30),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildScarecrowDisplay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.shade200,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 0.3,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (light == 1)
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(_glowAnimation.value * 0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                if (sound == 1) ...[
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                Icons.graphic_eq,
                                color: Colors.blue.withOpacity(_glowAnimation.value),
                                size: 20 + (index * 4),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusSection() {
    int activeFeatures = [moveScarecrow, sound, light].where((x) => x == 1).length;
    String statusText = activeFeatures == 0 ? "ක්‍රියා කරවීමට සූදානම්" : "$activeFeatures ක්‍රියා වෙමින් පවතී";
    Color statusColor = activeFeatures == 0 ? Colors.grey : Colors.green;

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

  Widget _buildControlButtons() {
    return Column(
      children: [
        _buildModernControlButton(
          "චලනය කරන්න",
          "MoveScareCrow",
          moveScarecrow,
          Icons.rotate_right,
          "Activate scarecrow movement",
        ),
        const SizedBox(height: 15),
        _buildModernControlButton(
          "ශබ්දය නගන්න",
          "Sound",
          sound,
          Icons.volume_up,
          "Play deterrent sounds",
        ),
        const SizedBox(height: 15),
        _buildModernControlButton(
          "ආලෝකය විහිදන්න",
          "light",
          light,
          Icons.lightbulb,
          "Flash warning lights",
        ),
      ],
    );
  }

  Widget _buildModernControlButton(
    String title,
    String key,
    int currentValue,
    IconData icon,
    String description,
  ) {
    bool isActive = currentValue == 1;

    return GestureDetector(
      onTap: () => _toggleValue(key, currentValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [Colors.green.shade600, Colors.green.shade800]
                : [Colors.grey.shade300, Colors.grey.shade500],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? "ON" : "OFF",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
     ),
);
}
}


// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../core_feature/NavBar.dart';

// class ScarecrowController extends StatefulWidget {
//   @override
//   _ScarecrowControllerState createState() => _ScarecrowControllerState();
// }

// class _ScarecrowControllerState extends State<ScarecrowController> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//   late FlutterLocalNotificationsPlugin _localNotifications;

//   int moveScarecrow = 0;
//   int sound = 0;
//   int light = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _listenForChanges();
//   }

//   void _initializeNotifications() {
//     _localNotifications = FlutterLocalNotificationsPlugin();

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings settings =
//         InitializationSettings(android: androidSettings);

//     _localNotifications.initialize(settings);
//   }

//   void _listenForChanges() {
//     _database.child('MoveScareCrow').onValue.listen((event) {
//       setState(() {
//         moveScarecrow = event.snapshot.value as int? ?? 0;
//       });
//     });

//     _database.child('Sound').onValue.listen((event) {
//       setState(() {
//         sound = event.snapshot.value as int? ?? 0;
//       });
//     });

//     _database.child('light').onValue.listen((event) {
//       setState(() {
//         light = event.snapshot.value as int? ?? 0;
//       });
//     });

//     // Listen for Detection changes and send notification
//     _database.child('Detection').onValue.listen((event) {
//       int detectionValue = event.snapshot.value as int? ?? 0;
//       if (detectionValue == 1) {
//         _sendNotification("Bird detected", "Scarecrow Moving");
//       }
//     });
//   }

//   Future<void> _sendNotification(String title, String body) async {
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

//   void _toggleValue(String key, int currentValue) {
//     int newValue = currentValue == 0 ? 1 : 0;
//     _database.child(key).set(newValue);
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
//                   Image.asset(
//                     'assets/images/srigoviya_logo.png',
//                     height: 30,
//                   ),
//                   const CircleAvatar(
//                     radius: 18,
//                     backgroundImage: AssetImage('assets/images/profile.png'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Text(
//                 "Scarecrow Controller",
//                 style: GoogleFonts.notoSansSinhala(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green.shade900,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Image.asset(
//                 'assets/images/watergate.png', // Replace with actual image path
//                 height: 150,
//               ),
//               const SizedBox(height: 30),
//               _buildButton("Moving", "MoveScareCrow", moveScarecrow),
//               const SizedBox(height: 10),
//               _buildButton("Sound", "Sound", sound),
//               const SizedBox(height: 10),
//               _buildButton("Light", "light", light),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(String text, String key, int currentValue) {
//     return ElevatedButton(
//       onPressed: () {
//         _toggleValue(key, currentValue);
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
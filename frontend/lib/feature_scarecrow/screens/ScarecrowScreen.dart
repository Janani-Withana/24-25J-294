import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
 
class ScarecrowScreen extends StatefulWidget {
  const ScarecrowScreen({super.key});
 
  @override
  _ScarecrowScreenState createState() => _ScarecrowScreenState();
}
 
class _ScarecrowScreenState extends State<ScarecrowScreen> {
  late VideoPlayerController _controller;
  bool isHandActive = false;
  bool isSoundActive = false;
  bool isLightActive = false;
  double dx = 0;
  double dy = 0;
 
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/videos/Elephant.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  void moveVideo(double x, double y) {
    setState(() {
      dx += x;
      dy += y;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/srigoviya_logo.png', height: 30),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: dy,
            left: dx,
            right: -dx,
            bottom: -dy,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.green, size: 30),
                  onPressed: () => moveVideo(0, -10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green, size: 30),
                  onPressed: () => moveVideo(-10, 0),
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.radio_button_checked, color: Colors.green),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.green, size: 30),
                  onPressed: () => moveVideo(10, 0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.green, size: 30),
                  onPressed: () => moveVideo(0, 10),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButton(
                  icon: Icons.waving_hand,
                  isActive: isHandActive,
                  onPressed: () => setState(() => isHandActive = !isHandActive),
                ),
                ToggleButton(
                  icon: Icons.graphic_eq,
                  isActive: isSoundActive,
                  onPressed: () => setState(() => isSoundActive = !isSoundActive),
                ),
                ToggleButton(
                  icon: Icons.lightbulb,
                  isActive: isLightActive,
                  onPressed: () => setState(() => isLightActive = !isLightActive),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
class ToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;
 
  const ToggleButton({super.key, required this.icon, required this.isActive, required this.onPressed});
 
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: isActive ? Colors.white : Colors.green),
      onPressed: onPressed,
      iconSize: 30,
      color: isActive ? Colors.green : Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isActive ? Colors.green : Colors.white,
        ),
        shape: WidgetStateProperty.all(
          const CircleBorder(),
        ),
      ),
    );
  }
}
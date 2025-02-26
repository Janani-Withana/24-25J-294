import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Logo
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'images/srigoviya_logo.png', // Replace with actual path
                  height: 40,
                ),
              ),

              const SizedBox(height: 20),

              // Illustration
              Image.asset(
                'images/login_illustration.png', // Replace with actual path
                height: 200,
              ),

              const SizedBox(height: 20),

              // Log In Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Log In",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Subtitle
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "please sign in to continue",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
                  hintText: "Email",
                  hintStyle: GoogleFonts.poppins(color: Colors.black45),
                  border: const UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
                  hintText: "password",
                  hintStyle: GoogleFonts.poppins(color: Colors.black45),
                  border: const UnderlineInputBorder(),
                  suffixIcon: const Icon(Icons.visibility_off, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Log In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Log in",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: Divider(color: Colors.black26)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "or sign in with",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.black26)),
                ],
              ),

              const SizedBox(height: 15),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('images/facebook.png'), // Replace with actual icon
                    iconSize: 10,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Image.asset('images/google.png'), // Replace with actual icon
                    iconSize: 10,
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account?",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "sign up",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

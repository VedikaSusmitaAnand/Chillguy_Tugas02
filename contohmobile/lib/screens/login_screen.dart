import 'package:flutter/material.dart';
import 'daftar_screen.dart';
import 'masuk_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildHeader(),
            const SizedBox(height: 30),
            Image.asset("assets/foto4.png", height: 295),
            const SizedBox(height: 30),
            _buildButton(
              context,
              "Sign Up",
              Colors.orange,
              false,
              const DaftarScreen(),
            ),
            const SizedBox(height: 8),
            const Text("Or"),
            const SizedBox(height: 8),
            _buildButton(
              context,
              "Sign In",
              Colors.orange,
              true,
              const MasukScreen(),
            ),
            const SizedBox(height: 8),
            _buildSocialIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.ramen_dining, size: 125, color: Colors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "ZERO",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                "HUNGER",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                "Helping other with kindness",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    bool filled,
    Widget screen,
  ) {
    return SizedBox(
      width: double.infinity,
      child:
          filled
              ? ElevatedButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(text, style: const TextStyle(color: Colors.white)),
              )
              : OutlinedButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen),
                    ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(text, style: TextStyle(color: color)),
              ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconButton("assets/google.png", 25),
        _iconButton("assets/email.jpg", 25),
        _iconButton("assets/facebook.png", 25),
      ],
    );
  }

  Widget _iconButton(String assetPath, double size) {
    return IconButton(
      icon: Image.asset(assetPath, width: size, height: size),
      onPressed: () {},
    );
  }
}

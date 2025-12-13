import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4965),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Face2Screen',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'AI Casting Match',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2D7A8C),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
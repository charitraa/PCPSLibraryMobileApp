import 'package:flutter/material.dart';
class Flashingpage extends StatefulWidget {
  const Flashingpage({super.key});

  @override
  State<Flashingpage> createState() => _FlashingpageState();
}

class _FlashingpageState extends State<Flashingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393A8F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/liblogo.png',
                width: 273,
                height: 273,
              ),
              const SizedBox(height: 10),
              const Spacer(),
              Column(
                children: [
                  const Text(
                    "From",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Image.asset(
                    'assets/images/pcpsLogo.png',
                    width: 150,
                    height: 60,
                  ),
                ],
              ),
              const SizedBox(height: 40), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

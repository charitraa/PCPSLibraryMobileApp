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
                    "from",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 20,
                      letterSpacing: 1.5,
                    ),
                  ),
                  // Image.asset(
                  //   'assets/images/pcps_bg.png',
                  //   width: 180,
                  //   height: 60,
                  // ),
                  const SizedBox(height: 8,),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.all(5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8), // Updated border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1.5,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Apply border radius to the image
                      child: Image.asset(
                        'assets/images/pcps.jpg',
                        width: 150,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
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
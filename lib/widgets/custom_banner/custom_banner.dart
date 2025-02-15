import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';

class CustomBanner extends StatefulWidget {
  final String text1;
  final String text2;

  const CustomBanner({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      color: AppColors.primary,
      width: double.infinity,
      height: 240,
      child: Stack(
        children: [

          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 120,
              height:40,
              child: const Image(
                image: AssetImage('assets/images/pcps_bg.png'),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Text(
              widget.text1,  // Access the text values from the widget
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Text(
              widget.text2,  // Access the text values from the widget
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
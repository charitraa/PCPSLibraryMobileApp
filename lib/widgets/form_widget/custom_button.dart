import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final int? width;


  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = const Color(0xFF393A8F),  this.width, // Default color

  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
        minimumSize: const MaterialStatePropertyAll(
          Size(double.infinity, 50),
        ),
        backgroundColor: MaterialStatePropertyAll(buttonColor),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color:Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
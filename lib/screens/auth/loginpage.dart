import 'package:flutter/material.dart';
import '../../resource/colors.dart';
import '../../widgets/CustomBanner/custom_banner.dart';
import '../../widgets/custom_textfield.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final String text1 = "Sign in";
  final String text2 = "Sign in to your account";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomBanner(text1: text1, text2: text2),
              CustomTextfield(hintText: "StudentID", outlinedColor: Colors.grey, focusedColor: AppColors.primary, width: size.width, text: "StudentID"),
            ],
          ),
        ),
      )
    );
  }
}

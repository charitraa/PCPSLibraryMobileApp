import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/explore/custom_textfield.dart';

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
    return Scaffold(
      body: SafeArea(child: Container()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/form_widget/custom_button.dart';
import 'package:library_management_sys/widgets/form_widget/custom_label_password.dart';
import '../../resource/colors.dart';
import '../../widgets/custom_banner/custom_banner.dart';
import '../../widgets/form_widget/custom_label_textfield.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 20),
                  child: Column(
                    children: [
                      CustomLabelTextfield(hintText: "StudentID", outlinedColor: Colors.grey, focusedColor: AppColors.primary, width: size.width, text: "StudentID"),
                    const SizedBox(height: 16,),
                      PasswordTextfield(obscureText: true,hintText: "Password", outlinedColor: Colors.grey, focusedColor: AppColors.primary, width: size.width, text: "Password"),
                      const SizedBox(height: 20,),
                      CustomButton(buttonColor:AppColors.primary,text: 'Login', onPressed: () {  },)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
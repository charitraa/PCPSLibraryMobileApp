import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/widgets/form_widget/custom_button.dart';
import 'package:library_management_sys/widgets/form_widget/custom_label_password.dart';
import 'package:provider/provider.dart';
import '../../resource/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_banner/custom_banner.dart';
import '../../widgets/form_widget/custom_label_textfield.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool isLoading = false;
  String username = '', password = '';
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
            isLoading
                ? const Center(
                    child: LinearProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20),
                    child: Column(
                      children: [
                        CustomLabelTextfield(
                          hintText: "College ID",
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          outlinedColor: Colors.black,
                          focusedColor: AppColors.primary,
                          width: size.width,
                          text: "College ID",
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PasswordTextfield(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: true,
                            hintText: "Password",
                            outlinedColor: Colors.black,
                            focusedColor: AppColors.primary,
                            width: size.width,
                            text: "Password"),
                        const SizedBox(
                          height: 8,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.of(context).push(
                        //           PageRouteBuilder(
                        //             pageBuilder: (context, animation,
                        //                     secondaryAnimation) =>
                        //                 const StudentNavBar(),
                        //             transitionsBuilder: (context, animation,
                        //                 secondaryAnimation, child) {
                        //               const begin = Offset(1.0, 0.0);
                        //               const end = Offset.zero;
                        //               const curve = Curves.easeInOut;
                        //               var tween = Tween(begin: begin, end: end)
                        //                   .chain(CurveTween(curve: curve));
                        //               var offsetAnimation =
                        //                   animation.drive(tween);
                        //               return SlideTransition(
                        //                 position: offsetAnimation,
                        //                 child: child,
                        //               );
                        //             },
                        //           ),
                        //         );
                        //       },
                        //       child: const Text(
                        //         'Forgot Password?',
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontFamily: 'poppins',
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //       width: 15,
                        //     )
                        //   ],
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (username.isEmpty || username == '') {
                              setState(() {
                                isLoading = false;
                              });
                              return Utils.flushBarErrorMessage(
                                  "Student ID is required", context);
                            }
                            if (password.isEmpty || password == '') {
                              setState(() {
                                isLoading = false;
                              });
                              return Utils.flushBarErrorMessage(
                                  "Student ID is required", context);
                            }
                            await Provider.of<AuthViewModel>(context,
                                    listen: false)
                                .login(
                                    {"cardId": username, "password": password},
                                    context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          buttonColor: AppColors.primary,
                          text: 'Login',
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ));
  }
}

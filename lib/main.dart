import 'package:flutter/material.dart';
import 'package:library_management_sys/custom_widget_test.dart';
import 'package:library_management_sys/screens/auth/login_page.dart';
import 'package:library_management_sys/screens/lib_nav.dart';
import 'package:library_management_sys/screens/student_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Loginpage(),
    );
  }
}

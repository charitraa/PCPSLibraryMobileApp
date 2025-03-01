import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/response/status.dart';
import '../../resource/routes_name.dart';
import '../../view_model/shared_pref_view_model.dart';
class Flashingpage extends StatefulWidget {
  const Flashingpage({super.key});

  @override
  State<Flashingpage> createState() => _FlashingpageState();
}

class _FlashingpageState extends State<Flashingpage> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    await _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? session = sp.getString('session');

    if (session != null) {
      final userDataViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await userDataViewModel.getUser(context);

      final user = userDataViewModel.currentUser;
      print(user?.roleId);
      if (userDataViewModel.userData.status == Status.ERROR || user == null) {
        _navigateTo(RoutesName.login);
      } else {
        _navigateTo(RoutesName.student);
      }
    } else {
      _navigateTo(RoutesName.login);
    }
  }

  // void _navigateBasedOnRole(String? role) {
  //   if (role == 'SuperAdmin' || role == 'Admin') {
  //     _navigateTo(RoutesName.admin);
  //   } else if (role == 'General') {
  //     _navigateTo(RoutesName.user);
  //   } else {
  //     _navigateTo(RoutesName.login);
  //   }
  // }

  void _navigateTo(String route) {
    Future.microtask(() {
      Navigator.pushReplacementNamed(context, route);
    });
  }
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

                  Container(
                    width: 180,
                    padding: const EdgeInsets.all(5),
                    height: 60,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(8),

                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/pcpsBackground.png',
                        width: 150,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
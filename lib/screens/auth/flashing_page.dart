import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/auth/login_page.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/widgets/no_internet_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/response/status.dart';
import '../../resource/routes_name.dart';
import '../introduction_screen/introduction_screen.dart';

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
    // final connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const MyPcpsIntroductionScreen()),
    //   );
    //   return;
    // }
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenIntro = prefs.getBool('isIntro') ?? false;
    if (!hasSeenIntro) {
      await prefs.setBool('hasSeenIntro', false);
    }
    if (hasSeenIntro == false) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MyIntroductionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
      return;
    }
    if (session != null) {
      final userDataViewModel =
          Provider.of<AuthViewModel>(context, listen: false);
      await userDataViewModel.getUser(context);
      final user = userDataViewModel.currentUser;
      if (userDataViewModel.userData.status == Status.ERROR || user == null) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Loginpage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const NoInternetWrapper(
                    child: StudentNavBar(
              index: 0,
            )),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
          (route) => false, // Remove all previous routes
        );
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF393A8F),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/pcpsNewLogo.png',
                width: size.width * 1,
                height: size.height * 0.5,
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
                    width: 200,
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

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:library_management_sys/screens/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyIntroductionScreen extends StatefulWidget {
  const MyIntroductionScreen({super.key});

  @override
  State<MyIntroductionScreen> createState() => _MyIntroductionScreenState();
}

class _MyIntroductionScreenState extends State<MyIntroductionScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIntro', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Loginpage()),
    );
  }

  Widget buildImage({double width = 280}) {
    return Image.asset('assets/images/logo_library.png', width: width);
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
      bodyPadding: EdgeInsets.all(20),
      bodyTextStyle: TextStyle(fontSize: 20.0),
      imagePadding: EdgeInsets.only(top: 40.0),
      pageColor: Colors.white,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to PCPS Library",
          body: "Explore a vast collection of books. Your reading journey starts here!",
          image: buildImage(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Discover & Reserve",
          body:
          "Browse a variety of books and reserve them with ease — anytime, anywhere.",
          image: buildImage(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manage Your Library",
          body:
    "Track dues, payments, reservation and stay updated with just a few taps!",
          image: buildImage(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward, color: Colors.blue),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.blue,
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
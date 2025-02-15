import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/routes_name.dart';
import 'package:library_management_sys/screens/auth/flashing_page.dart';
import 'package:library_management_sys/screens/auth/login_page.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/screens/unauthorised_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.flash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Flashingpage());

      case RoutesName.unauthorised:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UnauthorisedPage());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Loginpage());
      case RoutesName.student:
        return MaterialPageRoute(
            builder: (BuildContext context) => const StudentNavBar());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Flashingpage());
    }
  }
}

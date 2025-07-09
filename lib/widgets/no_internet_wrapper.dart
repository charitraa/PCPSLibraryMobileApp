import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:library_management_sys/widgets/no_internet_screen.dart';

class NoInternetWrapper extends StatelessWidget {
  final Widget child;

  const NoInternetWrapper({super.key, required this.child});

  Future<bool> checkInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return FutureBuilder<bool>(
          future: checkInternet(),
          builder: (context, internetSnapshot) {
            final hasInternet = internetSnapshot.data ?? true;

            if (!hasInternet) {
              return const NoInternetScreen();
            }

            return child;
          },
        );
      },
    );
  }
}

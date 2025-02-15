import 'package:flutter/cupertino.dart';
import 'package:library_management_sys/repository/auth_repository.dart';
import 'package:library_management_sys/utils/utils.dart';

import '../data/response/status.dart';
import '../model/user_model.dart';
import '../resource/routes_name.dart';

class AuthViewModel with ChangeNotifier {
  final _myrepo = AuthRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future login(dynamic body, BuildContext context) async {
    setLoading(true);

    try {
      final response = await _myrepo.login(body, context);
      if (response.status == Status.ERROR) {
        Utils.flushBarErrorMessage(
            response.message ?? "An error occurred", context);
      } else {
        Utils.flushBarSuccessMessage("User Logged in successfully!!!!", context);
        final String role = response.data?.role ?? "Unknown";
        UserModel user = UserModel(
          role: response.data?.role,
          email: response.data?.email,
        );
        setLoading(false);

        switch (role) {

          case 'Student':
            Navigator.pushReplacementNamed(context, RoutesName.student);
            break;
          default:
            Navigator.pushReplacementNamed(context, RoutesName.unauthorised);
            Utils.flushBarErrorMessage("Unknown role", context);
        }
      }
    } catch (error) {
      Utils.flushBarErrorMessage('$error', context);
      setLoading(false);
    }
  }
}

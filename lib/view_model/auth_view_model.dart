import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:library_management_sys/model/current_user_model.dart';
import 'package:library_management_sys/repository/auth_repository.dart';
import 'package:library_management_sys/screens/student/dashboard/student_dashboard.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/view_model/shared_pref_view_model.dart';

import '../data/response/api_response.dart';
import '../data/response/status.dart';
import '../model/user_model.dart';
import '../resource/routes_name.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _myrepo = AuthRepository();

  ApiResponse<CurrentUserModel> userData = ApiResponse.loading();

  CurrentUserModel? get currentUser => userData.data;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  void setUser(ApiResponse<CurrentUserModel> response) {
    userData = response;
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
        final String role = response.data?.roleId ?? "Unknown";
        UserModel user = UserModel(
          roleId: response.data?.roleId,
          email: response.data?.email,
        );
        setLoading(false);
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const StudentNavBar(index:2),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
        // switch (role) {
        //   case 'Student':
        //     Navigator.pushReplacementNamed(context, RoutesName.student);
        //     break;
        //   default:
        //     Navigator.pushReplacementNamed(context, RoutesName.unauthorised);
        //     Utils.flushBarErrorMessage("Unknown role", context);
        // }
      }
    } catch (error) {
      Utils.flushBarErrorMessage('$error', context);
      setLoading(false);
    }
  }
  Future<void> getUser(BuildContext context) async {
    setLoading(true);
    setUser(ApiResponse.loading());
    try {
      CurrentUserModel user = await _myrepo.getUser(context);
      if (kDebugMode) {
        print('User data: ${user.toJson()}');
      }
      setUser(ApiResponse.completed(user));
    } catch (e) {
      Navigator.pushReplacementNamed(context, RoutesName.login);
      setUser(ApiResponse.error(e.toString()));
    } finally {
      setLoading(false);
    }
  }
  Future<void> logout(BuildContext context) async {
    setLoading(true);
    try {
      final response = await _myrepo.logout(context);
      if (response.status == Status.COMPLETED) {
        Utils.flushBarSuccessMessage("User Logged out Successfully!", context);

        await UserViewModel().remove();
        Navigator.pushReplacementNamed(context, RoutesName.login);
      } else {
        Utils.flushBarErrorMessage(
            response.message ?? "An error occurred", context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
    } finally {
      setLoading(false);
    }
  }

}

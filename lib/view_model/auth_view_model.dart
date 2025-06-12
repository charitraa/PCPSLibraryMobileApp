import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:library_management_sys/model/current_user_model.dart';
import 'package:library_management_sys/repository/auth_repository.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/view_model/shared_pref_view_model.dart';
import 'package:logger/logger.dart';

import '../data/response/api_response.dart';
import '../data/response/status.dart';
import '../model/user_model.dart';
import '../resource/routes_name.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _myrepo = AuthRepository();
  final Logger _logger = Logger();

  ApiResponse<CurrentUserModel> userData = ApiResponse.loading();

  CurrentUserModel? get currentUser => userData.data;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  void setUser(ApiResponse<CurrentUserModel> response) {
    userData = response;
    Future.microtask(() => notifyListeners());
  }


  Future login(dynamic body, BuildContext context) async {
    setLoading(true);
    try {
      _logger.d('Login attempt with body: $body');
      final response = await _myrepo.login(body, context);
      if (response.status == Status.ERROR) {
        Utils.flushBarErrorMessage(
            response.message ?? "An error occurred", context);
      } else {
        Utils.flushBarSuccessMessage("User Logged in successfully!!!!", context);
        final String role = response.data?.roleId ?? "Unknown";
        UserModel user = UserModel(cardId: response.data?.cardId);
        setLoading(false);
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const StudentNavBar(index: 2),
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
      }
    } catch (error) {
      _logger.e('Login error: $error');
      Utils.flushBarErrorMessage('$error', context);
      setLoading(false);
    }
  }

  Future<void> getUser(BuildContext context) async {
    setLoading(true);
    setUser(ApiResponse.loading());
    try {
      CurrentUserModel user = await _myrepo.getUser(context);
      _logger.d('Fetched user: ${user.data?.userId}');
      setUser(ApiResponse.completed(user));
    } catch (e) {
      _logger.e('getUser error: $e');
      Utils.flushBarErrorMessage('Failed to fetch user: $e', context);
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
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
      _logger.e('Logout error: $e');
      Utils.flushBarErrorMessage("Error: $e", context);
    } finally {
      setLoading(false);
    }
  }
}
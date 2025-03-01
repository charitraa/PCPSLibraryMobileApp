import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    if(kDebugMode){
      print(user.session);
    }
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool sessionSaved = await sp.setString('session', user.session.toString());
    bool roleSaved = await sp.setString('role', user.roleId.toString());
    bool emailSaved = await sp.setString('email', user.email.toString());
    if (kDebugMode) {
      print('Role saved: $roleSaved ${sp.getString('session')}');
      print('Email saved: $emailSaved ${sp.getString('email')}');
    }

    notifyListeners();
    return sessionSaved && roleSaved && emailSaved ;
  }



  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? session = sp.getString('session');
    final String? role = sp.getString('role');
    return UserModel(session: session, roleId: role);
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('session');
    sp.remove('role');
    notifyListeners();
    return true;
  }

  Future<bool> isAuthenticated() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('session') != null;
  }

  Future<String?> getRole() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('role');
  }
}
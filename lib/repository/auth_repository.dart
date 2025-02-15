import 'package:flutter/cupertino.dart';
import 'package:library_management_sys/data/network/AuthNetworkApiService.dart';
import 'package:library_management_sys/data/response/api_response.dart';
import 'package:library_management_sys/endpoints/auth_endpoints.dart';
import 'package:library_management_sys/model/user_model.dart';

import '../utils/utils.dart';

class AuthRepository {
  final AuthNetworkApiService _apiService = AuthNetworkApiService();
  Future<dynamic> login(dynamic body,BuildContext context) async {
    try {
      dynamic response =
          await _apiService.getPostResponse(AuthEndPoints.authUrl, body);
      return ApiResponse.completed(UserModel.fromJson(response));
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      return ApiResponse.error(e.toString());
    }
  }
}

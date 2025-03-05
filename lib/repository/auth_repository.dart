import 'package:flutter/cupertino.dart';
import 'package:library_management_sys/data/network/AuthNetworkApiService.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/data/response/api_response.dart';
import 'package:library_management_sys/endpoints/auth_endpoints.dart';
import 'package:library_management_sys/model/user_model.dart';

import '../model/current_user_model.dart';
import '../utils/utils.dart';

class AuthRepository {
  final AuthNetworkApiService _apiService = AuthNetworkApiService();
  final BaseApiServices _baseService = NetworkApiService();
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
  Future<CurrentUserModel> getUser(BuildContext context) async {
    try {
      dynamic response =
      await _baseService.getApiResponse(AuthEndPoints.fetchUser);
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }

      return CurrentUserModel.fromJson(response);
    } catch (e) {
      print('errror $e.');
      return Utils.flushBarErrorMessage(e.toString(), context);
    }
  }
  Future<dynamic> logout(BuildContext context) async {
    try {
      final response = await _baseService.getDeleteApiResponse(AuthEndPoints.logout);

      if (response['status'] == 200) {
        return ApiResponse.completed(response);
      } else {
        return ApiResponse.error(response['errorMessage'] ?? "Unknown error");
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}

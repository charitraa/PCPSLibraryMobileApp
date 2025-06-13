import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:library_management_sys/data/network/AuthNetworkApiService.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/data/response/api_response.dart';
import 'package:library_management_sys/endpoints/auth_endpoints.dart';
import 'package:library_management_sys/model/user_model.dart';
import 'package:logger/logger.dart';

import '../model/current_user_model.dart';
import '../utils/utils.dart';

class AuthRepository {
  final AuthNetworkApiService _apiService = AuthNetworkApiService();
  final BaseApiServices _baseService = NetworkApiService();
  final Logger _logger = Logger();

  Future<ApiResponse<UserModel>> login(dynamic body, BuildContext context) async {
    try {
      _logger.d('Login request to ${AuthEndPoints.authUrl} with body: $body');
      final dynamic response =
      await _apiService.getPostResponse(AuthEndPoints.authUrl, body);
      if (response == null) {
        _logger.w('No response from login API');
        Utils.flushBarErrorMessage("No response from server", context);
        return ApiResponse.error("No response from server");
      }
      return ApiResponse.completed(UserModel.fromJson(response));
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for login');
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return ApiResponse.error("No internet connection");
    } catch (e) {
      _logger.e('Login error: $e');
      Utils.flushBarErrorMessage('Error: $e', context);
      return ApiResponse.error(e.toString());
    }
  }

  Future<CurrentUserModel?> getUser(BuildContext context) async {
    try {
      _logger.d('Fetching user from ${AuthEndPoints.fetchUser}');
      final dynamic response =
      await _baseService.getApiResponse(AuthEndPoints.fetchUser);
      if (response == null) {
        _logger.w('No response from getUser API');
        Utils.flushBarErrorMessage("No response from server", context);
        throw Exception("No response from server");
      }
      if (response['error'] != null && response['error'] == true) {
        final errorMessage = response['errorMessage'] ?? "Unknown error";
        _logger.e('API error fetching user: $errorMessage');
        Utils.flushBarErrorMessage(errorMessage, context);
        throw Exception(errorMessage);
      }
      _logger.d('Fetched user response: $response');
      return CurrentUserModel.fromJson(response);
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for fetching user');
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      throw Exception("No internet connection");
    } catch (e) {
      _logger.e('getUser error: $e');
      Utils.flushBarErrorMessage('Failed to fetch user: $e', context);
      throw e;
    }
  }

  Future<ApiResponse<dynamic>> logout(BuildContext context) async {
    try {
      _logger.d('Logout request to ${AuthEndPoints.logout}');
      final dynamic response =
      await _baseService.getDeleteApiResponse(AuthEndPoints.logout);
      if (response == null) {
        _logger.w('No response from logout API');
        Utils.flushBarErrorMessage("No response from server", context);
        return ApiResponse.error("No response from server");
      }
      if (response['status'] == 200) {
        _logger.d('Logout successful');
        return ApiResponse.completed(response);
      } else {
        final errorMessage = response['errorMessage'] ?? "Unknown error";
        _logger.w('Logout failed: $errorMessage');
        return ApiResponse.error(errorMessage);
      }
    } on TimeoutException {
      _logger.e('Timeout: No internet connection for logout');
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return ApiResponse.error("No internet connection");
    } catch (e) {
      _logger.e('Logout error: $e');
      Utils.flushBarErrorMessage('Error: $e', context);
      return ApiResponse.error(e.toString());
    }
  }
}
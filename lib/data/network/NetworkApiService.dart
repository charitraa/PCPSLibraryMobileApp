import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:library_management_sys/data/api_exception.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkApiService extends BaseApiServices {
  Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? session = sp.getString('session');
    if (kDebugMode) {
      print('Session: $session');
    }
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };
    if (session != null && session.isNotEmpty) {
      headers['Cookie'] = 'sessionId=$session';
    }

    return headers;
  }

  @override
  Future getApiResponse(String url) async {
    final headers = await _getHeaders();
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url) {
    throw UnimplementedError();
  }

  @override
  Future getPostApiResponse(String url, dynamic body) async {
    final headers = await _getHeaders();

    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    String error = "";
    if (responseBody is Map && responseBody.containsKey('error')) {
      error = responseBody['error'];
    }
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(error);
      case 401:
        throw UnAuthorizeException(error);
      case 403:
        throw FetchDataException("Forbidden: $error");
      case 404:
        throw FetchDataException("Not Found: $error");
      case 500:
        throw FetchDataException("Internal Server Error: $error");
      default:
        throw FetchDataException(
            'Error occured while communicating with server with status code ${response.statusCode.toString()}');
    }
  }

  @override
  Future postUrlResponse(String url) async {
    final headers = await _getHeaders();

    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }
}

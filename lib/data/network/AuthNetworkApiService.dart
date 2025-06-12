import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../model/user_model.dart';
import '../../view_model/shared_pref_view_model.dart';
import '../api_exception.dart';
import 'package:http/http.dart' as http;

class AuthNetworkApiService{
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: "application/json"
    };
    return headers;
  }
  Future getPostResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      )
          .timeout(const Duration(seconds: 10));
      final responseBody = jsonDecode(response.body);
      final session = response.headers['set-cookie']?.split(";")[0].split("=")[1];
      if (session != null) {
        UserModel user = UserModel(
            roleId: responseBody['roleId'],
            cardId: responseBody['cardId'],
            session: session);
        await UserViewModel().saveUser(user);
      } else {
        throw Exception('Incorrect username or password!!');
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
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
}
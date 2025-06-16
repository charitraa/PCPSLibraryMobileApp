import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/comment_endpoints.dart';
import 'package:library_management_sys/model/comment_model.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:logger/logger.dart';

class CommentsRepository {
  final BaseApiServices _apiService = NetworkApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchComments(
      String uid, String seed, int page, int limit, BuildContext context) async {
    String url =
        '${CommentEndpoints.comment}/$uid?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch comments URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No comments received from server", context);
        return {"comments": [], "next": null};
      }

      List<CommentModel> commentList = (response['data'] as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"comments": commentList, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching comments");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"comments": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching comments: $error");
      Utils.flushBarErrorMessage("Error fetching comments: $error", context);
      return {"comments": [], "next": null};
    }
  }

  Future<bool> postComments(String uid, dynamic body, BuildContext context) async {
    String url = "${CommentEndpoints.comment}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Post comments URL: $url");
      }
      final dynamic response = await _apiService.getPostApiResponse(url, body);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error posting comments: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for posting comments");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error posting comments: $error");
      Utils.flushBarErrorMessage("Error posting comments: $error", context);
      return false;
    }
  }

  Future<bool> replyComment(String uid, dynamic body, BuildContext context) async {
    String url = "${CommentEndpoints.commentReply}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Reply comment URL: $url");
      }
      final dynamic response = await _apiService.getPostApiResponse(url, body);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error replying to comment: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for replying to comment");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error replying to comment: $error");
      Utils.flushBarErrorMessage("Error replying to comment: $error", context);
      return false;
    }
  }

  Future<bool> updateComments(String uid, dynamic body, BuildContext context) async {
    String url = "${CommentEndpoints.updateComment}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Update comment URL: $url");
      }
      final dynamic response = await _apiService.getPostApiResponse(url, body);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error updating comment: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for updating comment");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error updating comment: $error");
      Utils.flushBarErrorMessage("Error updating comment: $error", context);
      return false;
    }
  }

  Future<bool> deleteComment(String uid, BuildContext context) async {
    String url = "${CommentEndpoints.deleteComment}/$uid";
    try {
      if (kDebugMode) {
        _logger.d("Delete comment URL: $url");
      }
      final dynamic response = await _apiService.getDeleteApiResponse(url);
      if (response['error'] != null && response['error'] == true) {
        _logger.w("Error deleting comment: ${response['errorMessage'] ?? 'Unknown error'}");
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        return false;
      }
      return true;
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for deleting comment");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return false;
    } catch (error) {
      _logger.e("Error deleting comment: $error");
      Utils.flushBarErrorMessage("Error deleting comment: $error", context);
      return false;
    }
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/comment_endpoints.dart';
import 'package:library_management_sys/model/comment_model.dart';
import 'package:library_management_sys/utils/utils.dart';

class CommentsRepository {
  final BaseApiServices _apiService = NetworkApiService();

  Future<Map<String, dynamic>> fetchComments(String uid, String seed, int page,
      int limit, BuildContext context) async {
    String url =
        '${CommentEndpoints.comment}/$uid?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      List<CommentModel> commentList = [];
      print(response['data']);
      if (response['data'] != null && response['data'] is List) {
        commentList = (response['data'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();
      }

      final next = response['info']?['next'] ?? '';

      print(commentList);
      return {"comments": commentList, "next": next};
    } catch (error) {
      print(error);
      return Utils.flushBarErrorMessage(error.toString(), context);
    }
  }

  Future<bool> postComments(
      String uid, dynamic body, BuildContext context) async {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          "${CommentEndpoints.comment}/$uid", body);
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      return true;
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
      return false;
    }
  }

  Future<bool> replyComment(
      String uid, dynamic body, BuildContext context) async {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          "${CommentEndpoints.commentReply}/$uid", body);
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      return true;
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
      return false;
    }
  }

  Future<bool> updateComments(
      String uid, dynamic body, BuildContext context) async {
    try {
      dynamic response = await _apiService.getPostApiResponse(
          "${CommentEndpoints.updateComment}/$uid", body);
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      return true;
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
      return false;
    }
  }

  Future<bool> deleteComment(String uid, BuildContext context) async {
    try {
      dynamic response = await _apiService
          .getDeleteApiResponse("${CommentEndpoints.deleteComment}/$uid");
      if (response['error'] != null && response['error'] == true) {
        Utils.flushBarErrorMessage(
            response['errorMessage'] ?? "Unknown error", context);
        throw Exception(response['errorMessage'] ?? "Unknown error");
      }
      return true;
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
      throw e;
      return false;
    }
  }
}

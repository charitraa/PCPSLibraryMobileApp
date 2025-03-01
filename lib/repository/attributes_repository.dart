import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/attribute_endpoints.dart';
import 'package:library_management_sys/model/author_model.dart';
import 'package:library_management_sys/model/genre_model.dart';
import 'package:library_management_sys/utils/utils.dart';

class AttributesRepository {
  final BaseApiServices _apiService = NetworkApiService();

  Future<Map<String, dynamic>> fetchGenre(
      String seed, int page, int limit, BuildContext context) async {
    String url =
        '${AttributeEndpoints.genreUrl}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      List<Genre> genre = [];
      if (response['data'] != null && response['data'] is List) {
        genre =
            (response['data'] as List).map((e) => Genre.fromJson(e)).toList();
      }
      final next = response['info']?['next'];

      return {"Genre": genre, "next": next};
    } catch (error) {
      return Utils.flushBarErrorMessage(error.toString(), context);
    }
  }

  Future<Map<String, dynamic>> fetchAuthor(
      String seed, int page, int limit, BuildContext context) async {
    String url =
        '${AttributeEndpoints.authorUrl}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        print(url);
      }
      dynamic response = await _apiService.getApiResponse(url);
      List<Author> author = [];
      if (response['data'] != null && response['data'] is List) {
        author =
            (response['data'] as List).map((e) => Author.fromJson(e)).toList();
      }
      final next = response['info']?['next'];

      return {"author": author, "next": next};
    } catch (error) {
      return Utils.flushBarErrorMessage(error.toString(), context);
    }
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/data/network/BaseApiService.dart';
import 'package:library_management_sys/data/network/NetworkApiService.dart';
import 'package:library_management_sys/endpoints/attribute_endpoints.dart';
import 'package:library_management_sys/model/Publisher_model.dart';
import 'package:library_management_sys/model/author_model.dart';
import 'package:library_management_sys/model/genre_model.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:logger/logger.dart';

class AttributesRepository {
  final BaseApiServices _apiService = NetworkApiService();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchGenre(
      String seed, int page, int limit, BuildContext context) async {
    String url =
        '${AttributeEndpoints.genreUrl}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch genre URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No genres received from server", context);
        return {"Genre": [], "next": null};
      }

      List<Genre> genre = (response['data'] as List)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"Genre": genre, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching genres");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"Genre": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching genres: $error");
      Utils.flushBarErrorMessage("Error fetching genres: $error", context);
      return {"Genre": [], "next": null};
    }
  }

  Future<Map<String, dynamic>> fetchAuthor(
      String seed, int page, int limit, BuildContext context) async {
    String url =
        '${AttributeEndpoints.authorUrl}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch author URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No authors received from server", context);
        return {"author": [], "next": null};
      }

      List<Author> author = (response['data'] as List)
          .map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"author": author, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching authors");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"author": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching authors: $error");
      Utils.flushBarErrorMessage("Error fetching authors: $error", context);
      return {"author": [], "next": null};
    }
  }

  Future<Map<String, dynamic>> fetchPublisher(
      String seed, int page, int limit, BuildContext context) async {
    String url =
        '${AttributeEndpoints.publisherUrl}?seed=$seed&page=$page&pageSize=$limit';
    try {
      if (kDebugMode) {
        _logger.d("Fetch publisher URL: $url");
      }
      final dynamic response = await _apiService.getApiResponse(url);
      if (response == null || response['data'] == null) {
        _logger.w("No data received from server for URL: $url");
        Utils.flushBarErrorMessage("No publishers received from server", context);
        return {"publisher": [], "next": null};
      }

      List<Publisher> publisher = (response['data'] as List)
          .map((e) => Publisher.fromJson(e as Map<String, dynamic>))
          .toList();
      final next = response['info']?['next'] ?? '';

      return {"publisher": publisher, "next": next};
    } on TimeoutException {
      _logger.e("Timeout: No internet connection for fetching publishers");
      Utils.flushBarErrorMessage("No internet connection. Please try again later.", context);
      return {"publisher": [], "next": null};
    } catch (error) {
      _logger.e("Error fetching publishers: $error");
      Utils.flushBarErrorMessage("Error fetching publishers: $error", context);
      return {"publisher": [], "next": null};
    }
  }
}
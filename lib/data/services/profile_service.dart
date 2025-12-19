import 'package:cours_work/data/models/bookmark.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getProfile() async {
    try {
    final Response<Map<String, dynamic>> res =
          await _dio.get<Map<String, dynamic>>('/profile/main');
    return res.data ?? {};
    } catch (e) {
      debugPrint('❌ getProfile error: $e');
      rethrow;
    }
  }

  Future<List<Bookmark>> getBookmarks() async {
    try {
    final Response<List<dynamic>> res =
          await _dio.get<List<dynamic>>('/profile/bookmarks');
      
      final data = res.data ?? [];
      return data
          .map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ getBookmarks error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> addBookmark(int articleId) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.post<Map<String, dynamic>>('/profile/bookmarks/$articleId');
      return res.data ?? {};
    } catch (e) {
      debugPrint('❌ addBookmark error: $e');
      rethrow;
    }
  }

  Future<void> removeBookmark(int articleId) async {
    try {
      await _dio.delete<dynamic>('/profile/bookmarks/$articleId');
    } catch (e) {
      debugPrint('❌ removeBookmark error: $e');
      rethrow;
    }
  }

}

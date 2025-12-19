import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AdminArticlesService {
  final Dio _dio = ApiClient.dio;

  Future<List<Article>> getAllArticles() async {
    try {
      final Response<List<dynamic>> res = await _dio.get<List<dynamic>>(
        '/admin/articles',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      final data = res.data ?? [];
      return data
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ getAllArticles (admin) error: $e');
      return [];
    }
  }

  Future<Article> createArticle({
    required String title,
    required String content,
    String? imageUrl,
    required int categoryId,
    int? issueId,
    bool isPremium = false,
  }) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.post<Map<String, dynamic>>(
        '/admin/articles',
        data: {
          'title': title,
          'content': content,
          if (imageUrl != null) 'image_url': imageUrl,
          'category_id': categoryId,
          if (issueId != null) 'issue_id': issueId,
          'is_premium': isPremium,
        },
      );

      if (res.data == null) {
        throw Exception('Failed to create article');
      }

      return Article.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ createArticle error: $e');
      rethrow;
    }
  }

  Future<Article> updateArticle({
    required int articleId,
    String? title,
    String? content,
    String? imageUrl,
    int? categoryId,
    int? issueId,
    bool? isPremium,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (imageUrl != null) data['image_url'] = imageUrl;
      if (categoryId != null) data['category_id'] = categoryId;
      if (issueId != null) data['issue_id'] = issueId;
      if (isPremium != null) data['is_premium'] = isPremium;

      final Response<Map<String, dynamic>> res =
          await _dio.put<Map<String, dynamic>>(
        '/admin/articles/$articleId',
        data: data,
      );

      if (res.data == null) {
        throw Exception('Failed to update article');
      }

      return Article.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ updateArticle error: $e');
      rethrow;
    }
  }

  Future<bool> deleteArticle(int articleId) async {
    try {
      final Response<dynamic> res = await _dio.delete('/admin/articles/$articleId');
      return res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300;
    } catch (e) {
      debugPrint('❌ deleteArticle error: $e');
      return false;
    }
  }
}


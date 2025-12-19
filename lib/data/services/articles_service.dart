import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ArticlesService {
  final Dio _dio = ApiClient.dio;

  Future<List<Article>> getAllArticles() async {
    try {
      final Response<List<dynamic>> res = await _dio.get<List<dynamic>>(
        '/articles/all',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      final data = res.data ?? [];
      return data
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ getAllArticles error: $e');
      return [];
    }
  }

  Future<List<Article>> getArticles({
    String? category,
    String? sort,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };
      
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }

      final Response<List<dynamic>> res = await _dio.get<List<dynamic>>(
        '/articles',
        queryParameters: queryParams,
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      final data = res.data ?? [];
      return data
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ getArticles error: $e');
      return [];
    }
  }

  Future<Article?> getArticleById(int articleId) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.get<Map<String, dynamic>>(
        '/articles/$articleId',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      if (res.data == null) return null;
      return Article.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ getArticleById error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> likeArticle(int articleId) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.post<Map<String, dynamic>>(
        '/articles/$articleId/like',
      );

      return res.data ?? {};
    } catch (e) {
      debugPrint('❌ likeArticle error: $e');
      rethrow;
    }
  }
}


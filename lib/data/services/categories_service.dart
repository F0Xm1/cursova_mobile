import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CategoriesService {
  final Dio _dio = ApiClient.dio;

  Future<List<Category>> getCategories() async {
    try {
      final Response<List<dynamic>> res = await _dio.get<List<dynamic>>(
        '/articles/categories/list',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      final data = res.data ?? [];
      return data
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ getCategories error: $e');
      return [];
    }
  }
}


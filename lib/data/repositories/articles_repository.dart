import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/services/articles_service.dart';
import 'package:cours_work/data/services/categories_service.dart';
import 'package:flutter/material.dart';

class ArticlesRepository {
  final ArticlesService _articlesService = ArticlesService();
  final CategoriesService _categoriesService = CategoriesService();

  Future<List<Article>> fetchAllArticles() async {
    return await _handle(
      _articlesService.getAllArticles,
      fallback: const [],
      label: 'fetchAllArticles',
    );
  }

  Future<List<Article>> fetchArticles({
    String? category,
    String? sort,
    int page = 1,
  }) async {
    return await _handle(
      () => _articlesService.getArticles(
        category: category,
        sort: sort,
        page: page,
      ),
      fallback: const [],
      label: 'fetchArticles',
    );
  }

  Future<Article?> fetchArticleById(int id) async {
    try {
      return await _articlesService.getArticleById(id);
    } catch (e) {
      debugPrint('❌ fetchArticleById error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> likeArticle(int articleId) async {
    try {
      return await _articlesService.likeArticle(articleId);
    } catch (e) {
      debugPrint('❌ likeArticle error: $e');
      rethrow;
    }
  }

  Future<List<Category>> fetchCategories() async {
    return await _handle(
      _categoriesService.getCategories,
      fallback: const [],
      label: 'fetchCategories',
    );
  }

  Future<T> _handle<T>(
    Future<T> Function() call, {
    required T fallback,
    required String label,
  }) async {
    try {
      return await call();
    } catch (e) {
      debugPrint('❌ $label error: $e');
      return fallback;
    }
  }
}


import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/services/admin_articles_service.dart';
import 'package:flutter/material.dart';

class AdminArticlesRepository {
  final AdminArticlesService _service = AdminArticlesService();

  Future<List<Article>> fetchAllArticles() async {
    try {
      return await _service.getAllArticles();
    } catch (e) {
      debugPrint('❌ fetchAllArticles (admin) error: $e');
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
      return await _service.createArticle(
        title: title,
        content: content,
        imageUrl: imageUrl,
        categoryId: categoryId,
        issueId: issueId,
        isPremium: isPremium,
      );
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
      return await _service.updateArticle(
        articleId: articleId,
        title: title,
        content: content,
        imageUrl: imageUrl,
        categoryId: categoryId,
        issueId: issueId,
        isPremium: isPremium,
      );
    } catch (e) {
      debugPrint('❌ updateArticle error: $e');
      rethrow;
    }
  }

  Future<bool> deleteArticle(int articleId) async {
    try {
      return await _service.deleteArticle(articleId);
    } catch (e) {
      debugPrint('❌ deleteArticle error: $e');
      return false;
    }
  }
}


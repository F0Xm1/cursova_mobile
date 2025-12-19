import 'package:cours_work/data/models/bookmark.dart';
import 'package:cours_work/data/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();

  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await _service.getProfile();
    } catch (e) {
      debugPrint('❌ getProfile error: $e');
      return {};
    }
  }

  Future<List<Bookmark>> getBookmarks() async {
    try {
      return await _service.getBookmarks();
    } catch (e) {
      debugPrint('❌ getBookmarks error: $e');
      return [];
    }
  }

  Future<bool> addBookmark(int articleId) async {
    try {
      await _service.addBookmark(articleId);
      return true;
    } catch (e) {
      debugPrint('❌ addBookmark error: $e');
      return false;
    }
  }

  Future<bool> removeBookmark(int articleId) async {
    try {
      await _service.removeBookmark(articleId);
      return true;
    } catch (e) {
      debugPrint('❌ removeBookmark error: $e');
      return false;
    }
  }

}

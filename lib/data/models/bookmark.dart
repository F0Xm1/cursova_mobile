import 'package:cours_work/data/models/article.dart';

class Bookmark {
  final int id;
  final Article article;
  final DateTime savedAt;

  Bookmark({
    required this.id,
    required this.article,
    required this.savedAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: (json['id'] ?? 0) as int,
      article: Article.fromJson(json['article'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['saved_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article': article.toJson(),
      'saved_at': savedAt.toIso8601String(),
    };
  }
}


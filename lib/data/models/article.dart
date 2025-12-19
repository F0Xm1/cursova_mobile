class Author {
  final int id;
  final String username;

  Author({
    required this.id,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: (json['id'] ?? 0) as int,
      username: (json['username'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String iconUrl;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      iconUrl: (json['icon_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon_url': iconUrl,
    };
  }
}

class Article {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final Author author;
  final Category category;
  final bool isPremium;
  final DateTime publishedAt;
  final int viewsCount;
  final int likesCount;
  final bool isSponsored;
  final int? pollId;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.category,
    required this.isPremium,
    required this.publishedAt,
    required this.viewsCount,
    required this.likesCount,
    this.isSponsored = false,
    this.pollId,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      isPremium: (json['is_premium'] ?? false) as bool,
      publishedAt: DateTime.parse(json['published_at'] as String? ?? DateTime.now().toIso8601String()),
      viewsCount: (json['views_count'] ?? 0) as int,
      likesCount: (json['likes_count'] ?? 0) as int,
      isSponsored: (json['is_sponsored'] ?? false) as bool,
      pollId: json['poll_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author': author.toJson(),
      'category': category.toJson(),
      'is_premium': isPremium,
      'published_at': publishedAt.toIso8601String(),
      'views_count': viewsCount,
      'likes_count': likesCount,
      'is_sponsored': isSponsored,
      'poll_id': pollId,
    };
  }

  int get readingTimeMinutes {
    final wordCount = content.split(' ').length;
    return (wordCount / 200).ceil();
  }
}

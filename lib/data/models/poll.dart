class Poll {
  final int id;
  final String question;
  final List<String> options;
  final Map<String, int> results;
  final int? articleId;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.results,
    this.articleId,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    final resultsData = json['results'] as Map<String, dynamic>? ?? {};
    final results = resultsData.map((key, value) => MapEntry(key, value as int));

    return Poll(
      id: (json['id'] ?? 0) as int,
      question: (json['question'] ?? '') as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      results: results,
      articleId: json['article_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'results': results,
      'article_id': articleId,
    };
  }
}


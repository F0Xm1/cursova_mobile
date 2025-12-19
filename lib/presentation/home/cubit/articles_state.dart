part of 'articles_cubit.dart';

abstract class ArticlesState {}

class ArticlesInitial extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesLoaded extends ArticlesState {
  final List<Article> articles;
  final List<Article> featuredArticles;
  final List<Category> categories;
  final String? selectedCategory;
  final String? sortBy;
  
  ArticlesLoaded({
    required this.articles,
    this.featuredArticles = const [],
    this.categories = const [],
    this.selectedCategory,
    this.sortBy,
  });
}

class ArticlesError extends ArticlesState {
  final String message;
  ArticlesError(this.message);
}


import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/repositories/articles_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository _repository;

  ArticlesCubit(this._repository) : super(ArticlesInitial());

  Future<void> loadArticles() async {
    if (state is ArticlesLoading) return;
    emit(ArticlesLoading());

    try {
      final articles = await _repository.fetchAllArticles();
      final categories = await _repository.fetchCategories();

      final featuredArticles = articles
        ..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
      final featured = featuredArticles.take(5).toList();

      if (articles.isEmpty) {
        emit(ArticlesError('Список статей порожній'));
      } else {
        emit(
          ArticlesLoaded(
            articles: articles,
            featuredArticles: featured,
            categories: categories,
          ),
        );
      }
    } catch (e) {
      emit(ArticlesError('Помилка при завантаженні: $e'));
    }
  }

  Future<void> filterByCategory(String? categorySlug) async {
    emit(ArticlesLoading());
    try {
      final articles = await _repository.fetchArticles(
        category: categorySlug,
        sort: (state as ArticlesLoaded).sortBy,
      );

      final currentState = state as ArticlesLoaded;
      emit(
        ArticlesLoaded(
          articles: articles,
          featuredArticles: currentState.featuredArticles,
          categories: currentState.categories,
          selectedCategory: categorySlug,
          sortBy: currentState.sortBy,
        ),
      );
    } catch (e) {
      emit(ArticlesError('Помилка при фільтрації: $e'));
    }
  }

  Future<void> sortArticles(String sortBy) async {
    emit(ArticlesLoading());
    try {
      final currentState = state as ArticlesLoaded;
      final articles = await _repository.fetchArticles(
        category: currentState.selectedCategory,
        sort: sortBy,
      );

      emit(
        ArticlesLoaded(
          articles: articles,
          featuredArticles: currentState.featuredArticles,
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
          sortBy: sortBy,
        ),
      );
    } catch (e) {
      emit(ArticlesError('Помилка при сортуванні: $e'));
    }
  }

  Future<void> refresh() async {
    await loadArticles();
  }
}

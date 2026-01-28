//HomePage
import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/home/cubit/articles_cubit.dart';
import 'package:cours_work/presentation/home/widgets/article_card.dart';
import 'package:cours_work/presentation/home/widgets/featured_article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _featuredController = PageController();
  String? _selectedCategorySlug;

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          if (state is ArticlesLoading && state is! ArticlesLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ArticlesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppFonts.lato(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ArticlesCubit>().loadArticles();
                    },
                    child: const Text('Повторити'),
                  ),
                ],
              ),
            );
          }

          if (state is ArticlesLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80,
                  floating: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: Text(
                      'Magazine',
                      style: AppFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, color: AppColors.text),
                      onPressed: () {
                        // TODO: Navigate to search
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.text,
                      ),
                      onPressed: () {
                        // TODO: Navigate to notifications
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                if (state.featuredArticles.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 350,
                      child: PageView.builder(
                        controller: _featuredController,
                        itemCount: state.featuredArticles.length,
                        itemBuilder: (context, index) {
                          final article = state.featuredArticles[index];
                          return FeaturedArticleCard(
                            article: article,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.articleDetails,
                                arguments: article,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text('All'),
                              selected: _selectedCategorySlug == null,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategorySlug = null;
                                  });
                                  context
                                      .read<ArticlesCubit>()
                                      .filterByCategory(null);
                                }
                              },
                            ),
                          ),
                          ...state.categories.map((category) {
                            final isSelected =
                                _selectedCategorySlug == category.slug;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategorySlug = selected
                                        ? category.slug
                                        : null;
                                  });
                                  context
                                      .read<ArticlesCubit>()
                                      .filterByCategory(
                                        selected ? category.slug : null,
                                      );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                if (state.articles.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('Немає статей')),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final article = state.articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.articleDetails,
                            arguments: article,
                          );
                        },
                      );
                    }, childCount: state.articles.length),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

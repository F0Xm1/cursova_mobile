import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart';
import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/repositories/admin_articles_repository.dart';
import 'package:cours_work/data/repositories/articles_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:flutter/material.dart';

class AdminArticlesPage extends StatefulWidget {
  const AdminArticlesPage({super.key});

  @override
  State<AdminArticlesPage> createState() => _AdminArticlesPageState();
}

class _AdminArticlesPageState extends State<AdminArticlesPage> {
  final AdminArticlesRepository _adminRepo = AdminArticlesRepository();
  final ArticlesRepository _articlesRepo = ArticlesRepository();

  List<Article> _articles = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isAdmin = await LocalStorage.getIsAdmin();
    if (!isAdmin) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    setState(() => _loading = true);
    try {
      final articles = await _adminRepo.fetchAllArticles();
      final categories = await _articlesRepo.fetchCategories();
      if (mounted) {
        setState(() {
          _articles = articles;
          _categories = categories;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteArticle(int articleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Видалити статтю?'),
        content: const Text('Цю дію неможливо скасувати.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _adminRepo.deleteArticle(articleId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Статтю видалено' : 'Помилка при видаленні'),
        ),
      );

      if (success) _loadData();
    }
  }

  void _showCreateDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => _ArticleEditDialog(
        categories: _categories,
        onSuccess: _loadData,
      ),
    );
  }

  void _showEditDialog(Article article) {
    showDialog<void>(
      context: context,
      builder: (_) => _ArticleEditDialog(
        article: article,
        categories: _categories,
        onSuccess: _loadData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorage.getIsAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == false) {
          return Scaffold(
            appBar: AppBar(title: const Text('Адмін панель')),
            body: const Center(child: Text('У вас немає доступу')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              'Управління статтями',
              style: AppFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showCreateDialog,
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : _articles.isEmpty
              ? const Center(child: Text('Немає статей'))
              : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: article.imageUrl.isNotEmpty
                            ? Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) =>
                          const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        )
                            : const Icon(Icons.article),
                      ),
                    ),

                    title: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      article.category.name,
                      style: AppFonts.lato(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditDialog(article);
                        } else if (value == 'delete') {
                          _deleteArticle(article.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Редагувати'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Видалити',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class _ArticleEditDialog extends StatefulWidget {
  final Article? article;
  final List<Category> categories;
  final VoidCallback onSuccess;

  const _ArticleEditDialog({
    this.article,
    required this.categories,
    required this.onSuccess,
  });

  @override
  State<_ArticleEditDialog> createState() => _ArticleEditDialogState();
}

class _ArticleEditDialogState extends State<_ArticleEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int? _selectedCategoryId;
  bool _isPremium = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _contentController.text = widget.article!.content;
      _imageUrlController.text = widget.article!.imageUrl;
      _selectedCategoryId = widget.article!.category.id;
      _isPremium = widget.article!.isPremium;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    setState(() => _loading = true);
    final repo = AdminArticlesRepository();

    try {
      if (widget.article == null) {
        await repo.createArticle(
          title: _titleController.text,
          content: _contentController.text,
          imageUrl:
          _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
          categoryId: _selectedCategoryId!,
          isPremium: _isPremium,
        );
      } else {
        await repo.updateArticle(
          articleId: widget.article!.id,
          title: _titleController.text,
          content: _contentController.text,
          imageUrl:
          _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
          categoryId: _selectedCategoryId,
          isPremium: _isPremium,
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Заголовок'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Введіть заголовок' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageUrlController,
                  decoration:
                  const InputDecoration(labelText: 'URL зображення'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration:
                  const InputDecoration(labelText: 'Категорія'),
                  items: widget.categories
                      .map(
                        (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    ),
                  )
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedCategoryId = v),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _isPremium,
                  onChanged: (v) =>
                      setState(() => _isPremium = v ?? false),
                  title: const Text('Premium стаття'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Контент'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: const Text('Зберегти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

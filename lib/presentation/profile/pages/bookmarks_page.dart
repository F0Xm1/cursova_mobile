import 'package:cours_work/data/models/bookmark.dart';
import 'package:cours_work/data/repositories/profile_repository.dart';
import 'package:cours_work/presentation/home/widgets/article_card.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final ProfileRepository _repo = ProfileRepository();
  List<Bookmark> _bookmarks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _loading = true);
    try {
      final bookmarks = await _repo.getBookmarks();
      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Немає збережених статей',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookmarks,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = _bookmarks[index];
          return ArticleCard(
            article: bookmark.article,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.articleDetails,
                arguments: bookmark.article,
              );
            },
          );
        },
      ),
    );
  }
}


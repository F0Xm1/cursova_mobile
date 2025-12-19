import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/presentation/home/widgets/article_card.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Article> _history = [];

  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Історія переглядів порожня',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final article = _history[index];
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
      },
    );
  }
}


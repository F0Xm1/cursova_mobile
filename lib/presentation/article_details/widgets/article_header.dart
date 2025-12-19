import 'package:flutter/material.dart';

import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart';
import 'package:cours_work/data/models/article.dart';

class ArticleHeader extends StatelessWidget {
  final Article article;
  final bool isBookmarked;
  final VoidCallback onShare;
  final VoidCallback onBookmark;

  const ArticleHeader({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onShare,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: AppFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                article.author.username.isNotEmpty
                    ? article.author.username[0].toUpperCase()
                    : 'A',
                style: AppFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.author.username,
                    style: AppFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    _formatDate(article.publishedAt),
                    style: AppFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.grey),
              onPressed: onShare,
            ),
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color:
                isBookmarked ? AppColors.primary : Colors.grey,
              ),
              onPressed: onBookmark,
            ),
            const Icon(Icons.favorite_border,
                size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${article.likesCount}',
              style: AppFonts.roboto(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}.${date.month}.${date.year}';
}

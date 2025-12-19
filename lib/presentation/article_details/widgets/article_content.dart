import 'dart:ui';

import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/data/models/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleContent extends StatelessWidget {
  final Article article;
  final bool isPremiumBlocked;

  const ArticleContent({
    super.key,
    required this.article,
    required this.isPremiumBlocked,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPremiumBlocked) {
      return HtmlWidget(article.content);
    }

    return Stack(
      children: [
        SizedBox(height: 300, child: HtmlWidget(article.content)),
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withOpacity(0.8),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

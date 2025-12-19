import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/data/models/article.dart';
import 'package:cours_work/data/models/poll.dart';
import 'package:cours_work/data/repositories/articles_repository.dart';
import 'package:cours_work/data/repositories/polls_repository.dart';
import 'package:cours_work/data/repositories/profile_repository.dart';
import 'package:cours_work/data/repositories/subscription_repository.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/article_details/widgets/article_content.dart';
import 'package:cours_work/presentation/article_details/widgets/article_header.dart';
import 'package:cours_work/presentation/article_details/widgets/poll_widget.dart';
import 'package:flutter/material.dart';

class ArticleDetailsPage extends StatefulWidget {
  final Article article;

  const ArticleDetailsPage({super.key, required this.article});

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  final ArticlesRepository _articlesRepo = ArticlesRepository();
  final PollsRepository _pollsRepo = PollsRepository();
  final SubscriptionRepository _subscriptionRepo = SubscriptionRepository();
  final ProfileRepository _profileRepo = ProfileRepository();

  Article? _fullArticle;
  Poll? _activePoll;
  bool _isUserSubscribed = false;
  bool _isBookmarked = false;
  bool _bookmarkLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkSubscriptionAndAds();
    _checkBookmark();
  }

  Future<void> _loadData() async {
    try {
      final article = await _articlesRepo.fetchArticleById(widget.article.id);
      if (mounted) {
        setState(() => _fullArticle = article ?? widget.article);
        _loadPoll(1);
      }
    } catch (_) {
      setState(() => _fullArticle = widget.article);
      _loadPoll(1);
    }
  }

  Future<void> _loadPoll(int pollId) async {
    try {
      final poll = await _pollsRepo.fetchPoll(pollId);
      if (mounted && poll != null) {
        setState(() => _activePoll = poll);
      }
    } catch (_) {}
  }

  Future<void> _checkSubscriptionAndAds() async {
    try {
      final sub = await _subscriptionRepo.getSubscriptionStatus();
      setState(() => _isUserSubscribed = sub?.isValid ?? false);
      if (!_isUserSubscribed) _scheduleAd();
    } catch (_) {
      _scheduleAd();
    }
  }

  Future<void> _checkBookmark() async {
    try {
      final bookmarks = await _profileRepo.getBookmarks();
      setState(() {
        _isBookmarked = bookmarks.any((b) => b.article.id == widget.article.id);
      });
    } catch (_) {}
  }

  Future<void> _toggleBookmark() async {
    if (_bookmarkLoading) return;

    setState(() => _bookmarkLoading = true);

    final success = _isBookmarked
        ? await _profileRepo.removeBookmark(widget.article.id)
        : await _profileRepo.addBookmark(widget.article.id);

    if (success && mounted) {
      setState(() => _isBookmarked = !_isBookmarked);
    }

    setState(() => _bookmarkLoading = false);
  }

  void _scheduleAd() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isUserSubscribed) {
        _showAdDialog();
      }
    });
  }

  void _showAdDialog() {
    final random = Random().nextInt(4) + 1;

    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          'assets/images/advertising_$random.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _handlePollVote(String option) async {
    if (_activePoll == null) return;
    await _pollsRepo.votePoll(pollId: _activePoll!.id, selectedOption: option);
    _loadPoll(_activePoll!.id);
  }

  void _navigateToSubscription() {
    Navigator.pushNamed(context, AppRoutes.subscription);
  }

  void _shareArticle() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Посилання скопійовано')));
  }

  @override
  Widget build(BuildContext context) {
    final article = _fullArticle ?? widget.article;
    final isPremiumBlocked = article.isPremium && !_isUserSubscribed;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArticleHeader(
                    article: article,
                    isBookmarked: _isBookmarked,
                    onShare: _shareArticle,
                    onBookmark: _toggleBookmark,
                  ),
                  const SizedBox(height: 24),
                  ArticleContent(
                    article: article,
                    isPremiumBlocked: isPremiumBlocked,
                  ),
                  if (isPremiumBlocked) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _navigateToSubscription,
                        child: const Text('Підписатися для читання'),
                      ),
                    ),
                  ],
                  if (!isPremiumBlocked && _activePoll != null)
                    PollWidget(poll: _activePoll!, onVote: _handlePollVote),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

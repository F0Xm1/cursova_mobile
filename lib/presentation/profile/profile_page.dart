import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart';
import 'package:cours_work/data/repositories/profile_repository.dart';
import 'package:cours_work/data/repositories/subscription_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/profile/pages/bookmarks_page.dart';
import 'package:cours_work/presentation/profile/pages/history_page.dart';
import 'package:cours_work/presentation/profile/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final ProfileRepository _repo = ProfileRepository();
  final SubscriptionRepository _subscriptionRepo = SubscriptionRepository();

  String username = 'User';
  String email = '';
  bool isPremium = false;
  bool isAdmin = false;
  bool loading = true;

  late TabController _tabController;

  static const Color _darkCard = Color(0xFF161616);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _repo.getProfile();
      final subscription = await _subscriptionRepo.getSubscriptionStatus();

      final name = (profile['username'] ?? '').toString();
      final userEmail = (profile['email'] ?? '').toString();
      final int id = profile['user_id'] as int;
      final bool premium = subscription?.isValid ?? false;

      final bool admin = name.toLowerCase() == 'administrator' || id == 1;
      await LocalStorage.saveIsAdmin(admin);

      setState(() {
        username = name;
        email = userEmail;
        isPremium = premium;
        isAdmin = admin;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    await prefs.remove('is_admin');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Профіль',
          style: AppFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.text),
            onPressed: _logout,
            tooltip: 'Вийти',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Закладки'),
            Tab(text: 'Історія'),
            Tab(text: 'Налаштування'),
          ],
        ),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (!isPremium) _PremiumBanner(),

                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.background,
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'U',
                      style: AppFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  username,
                  style: AppFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),

                if (email.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: AppFonts.lato(
                      fontSize: 14,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                _StatusBadge(isPremium: isPremium),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      BookmarksPage(),
                      HistoryPage(),
                      SettingsPage(),
                    ],
                  ),
                ),

                if (isAdmin)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        top: BorderSide(
                          color: AppColors.text.withOpacity(0.12),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _darkCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Адмін панель',
                                style: AppFonts.merriweather(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.adminArticles,
                                );
                              },
                              icon: const Icon(Icons.article),
                              label: const Text('Управління статтями'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(
                                  color:
                                  AppColors.primary.withOpacity(0.65),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================== SUB WIDGETS ================== */

class _PremiumBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.premiumGold,
            AppColors.premiumGold.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.subscription),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Оновіться до Premium',
                    style: AppFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Отримайте доступ до всіх статей',
                    style: AppFonts.roboto(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isPremium;

  const _StatusBadge({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPremium ? AppColors.premiumGold : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPremium ? 'Premium' : 'Free',
        style: AppFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isPremium ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }
}
